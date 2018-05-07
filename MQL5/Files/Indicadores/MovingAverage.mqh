//+------------------------------------------------------------------+
//|                                               BollingerBands.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#include "..\Configs.mqh"
#include "..\IndicadoresConfigs\MovingAverageConfig.mqh"

class Moving_Average
{
   private:
      ENUM_FEEDBACK_TYPE   feedbackType;
      double               feedbackForce;
   
      int                  handleShortPeriod;
      int                  handleMediumPeriod;
      int                  handleLongPeriod;
      
      double               shortPeriodArray[];
      double               mediumPeriodArray[];
      double               longPeriodArray[];
      
      datetime             timeArray[];
      
      void                 setHandlers(string               _symbol,
                                       ENUM_TIMEFRAMES      _period,       
                                       uint                 _shortPeriod,
                                       uint                 _mediumPeriod,
                                       uint                 _longPeriod, 
                                       int                  _Shift,
                                       ENUM_MA_METHOD       _method,
                                       ENUM_APPLIED_PRICE   _applied_price);
                                    
      void                 sortIndicators(string           _symbol,
                                          ENUM_TIMEFRAMES  _period,
                                          int              _amountCopy);
      
   protected:
   
   public:
      Moving_Average_Configuration MovingAverageConfigs;
      
      ENUM_FEEDBACK_TYPE   getFeedBackType(void)    { return this.feedbackType; }
      
      double               getFeedbackForce(void)   { return this.feedbackForce; }
      
      void                 openIndicator(string           _symbol,
                                         ENUM_TIMEFRAMES  _period);
                                      
      void                 getFeedBack(string           _symbol,
                                       ENUM_TIMEFRAMES  _period,
                                       datetime         _locked_bar_time);                                   
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Moving_Average::setHandlers(string               _symbol,
                                 ENUM_TIMEFRAMES      _period,       
                                 uint                 _shortPeriod,
                                 uint                 _mediumPeriod,
                                 uint                 _longPeriod, 
                                 int                  _Shift,
                                 ENUM_MA_METHOD       _method,
                                 ENUM_APPLIED_PRICE   _applied_price)
{
   ////////////////////////////
   // First, short Period MA //
   ////////////////////////////
   this.handleShortPeriod  = iMA(_symbol,
                                 _period,
                                 _shortPeriod,
                                 _Shift,
                                 _method,
                                 _applied_price);
   
   if(this.handleShortPeriod < 0)
   {
      Print("Failed to create a handle for the Shorter Moving Average for ", _symbol, " . Handle = ", INVALID_HANDLE,
            "\n Error = ", GetLastError());
   
      ExpertRemove();
   }
   
   //////////////////////////////
   // Second, medium Period MA //
   //////////////////////////////
   /*this.handleMediumPeriod  = iMA(_symbol,
                                  _period,
                                  _mediumPeriod,
                                  _Shift,
                                  _method,
                                  _applied_price);
                                         
   if(this.handleMediumPeriod < 0)
   {
      Print("Failed to create a handle for the Medium Moving Average for ", _symbol, " . Handle = ", INVALID_HANDLE,
            "\n Error = ", GetLastError());
   
      ExpertRemove();
   }*/
   
   /////////////////////////////
   // Finally, long Period MA //
   /////////////////////////////
   this.handleLongPeriod  = iMA(_symbol,
                                _period,
                                _longPeriod,
                                _Shift,
                                _method,
                                _applied_price);
                                         
   if(this.handleLongPeriod < 0)
   {
      Print("Failed to create a handle for the Longer Moving Average for ", _symbol, " . Handle = ", INVALID_HANDLE,
            "\n Error = ", GetLastError());
   
      ExpertRemove();
   }
         
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Moving_Average::openIndicator(string           _symbol,
                                   ENUM_TIMEFRAMES  _period)
{
   this.setHandlers(_symbol,
                    _period,
                    this.MovingAverageConfigs.getShortPeriod(),
                    this.MovingAverageConfigs.getMediumPeriod(),
                    this.MovingAverageConfigs.getLongPeriod(),
                    this.MovingAverageConfigs.getShift(),
                    this.MovingAverageConfigs.getMethod(),
                    this.MovingAverageConfigs.getAppliedPrice());

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Moving_Average::sortIndicators(string           _symbol,
                                    ENUM_TIMEFRAMES  _period,
                                    int              _amountCopy)
{
   ////////////////////////////////////////////////
   // Sort the price of the shorter MA downwards // 
   ////////////////////////////////////////////////
   CopyBuffer(this.handleShortPeriod,
              0,
              this.MovingAverageConfigs.getShift(),
              _amountCopy,
              this.shortPeriodArray);
              
   ArraySetAsSeries(this.shortPeriodArray,
                    true);           
   
   ///////////////////////////////////////////////
   // Sort the price of the medium MA downwards // 
   ///////////////////////////////////////////////
   CopyBuffer(this.handleMediumPeriod,
              0,
              this.MovingAverageConfigs.getShift(),
              _amountCopy,
              this.mediumPeriodArray);
   
   ArraySetAsSeries(this.mediumPeriodArray,
                    true);
   
   ///////////////////////////////////////////////
   // Sort the price of the longer MA downwards // 
   ///////////////////////////////////////////////
   CopyBuffer(this.handleLongPeriod,
              0,
              this.MovingAverageConfigs.getShift(),
              _amountCopy,
              this.longPeriodArray);
   
   ArraySetAsSeries(this.longPeriodArray,
                    true);      
                    
   /////////////////////////////////////
   // Opening time of the current bar //
   ///////////////////////////////////// 
   if(CopyTime(_symbol,
               _period,
               0,
               _amountCopy,
               this.timeArray) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.timeArray,
                    true);                          
              
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Moving_Average::getFeedBack(string           _symbol,
                                 ENUM_TIMEFRAMES  _period,
                                 datetime         _locked_bar_time)
{
   this.sortIndicators(_symbol,
                       _period,
                       3);
   
   //////////////////////////////////////
   // Restrictions on position opening //
   //////////////////////////////////////
   
   // A position has already been opened on the current bar
   if(_locked_bar_time >= (this.timeArray[0]))
   { 
      this.feedbackType = DO_NOTHING;
      
      return;
   }
   
   //////////////////////////////
   // Check for a Golden Cross //
   //////////////////////////////
   if((this.shortPeriodArray[0] > this.longPeriodArray[0]) && 
      (this.shortPeriodArray[1] < this.longPeriodArray[1]))
   {
      this.feedbackType = BUY;
   
      return;
   }
   
   /////////////////////////////
   // Check for a Death Cross //
   /////////////////////////////
   if((this.shortPeriodArray[0] < this.longPeriodArray[0]) && 
      (this.shortPeriodArray[1] > this.longPeriodArray[1]))
   {
      this.feedbackType = SELL;
      
      return;
   }
   
   this.feedbackType = DO_NOTHING;
   
   return;
}