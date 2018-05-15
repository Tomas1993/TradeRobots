//+------------------------------------------------------------------+
//|                                        RelativeStrenghtIndex.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#include "..\Configs.mqh"
#include "..\IndicadoresConfigs\RelativeStrenghtIndexConfig.mqh"

class RSI
{
   private:
      ENUM_FEEDBACK_TYPE               feedbackType;
   
      int                              handleAveragePeriod;
      
      double                           averagePeriodArray[];
      
      datetime                         timeArray[];
      
      void                             setHandlers(
                                          string                     _symbol,
                                          ENUM_TIMEFRAMES            _period,       
                                          uint                       _averagePeriod,
                                          ENUM_APPLIED_PRICE         _applied_price
                                       );
                                    
      void                             sortIndicators(
                                          string                     _symbol,
                                          ENUM_TIMEFRAMES            _period,
                                          int                        _amountCopy
                                       );
                                       
      void                             informUser(
                                          bool                       _successful
                                       );
      
   protected:
   
   public:
      RSI_Configuration                RSIConfigs;
      
      ENUM_FEEDBACK_TYPE               getFeedBackType(void)         { return this.feedbackType; }
      
      void                             openIndicator(
                                          string                     _symbol,
                                          ENUM_TIMEFRAMES            _period
                                       );
                                      
      void                             getFeedBack(
                                          string                     _symbol,
                                          ENUM_TIMEFRAMES            _period,
                                          datetime                   _locked_bar_time
                                       );                                   
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RSI::setHandlers(string               _symbol,
                      ENUM_TIMEFRAMES      _period,       
                      uint                 _averagePeriod,
                      ENUM_APPLIED_PRICE   _applied_price)
{
   ////////////////////////////
   // First, short Period MA //
   ////////////////////////////
   this.handleAveragePeriod  = iRSI(_symbol,
                                    _period,
                                    _averagePeriod,
                                    _applied_price);
   
   if(this.handleAveragePeriod < 0)
   {
      this.informUser(false);
   }
      
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RSI::openIndicator(string           _symbol,
                        ENUM_TIMEFRAMES  _period)
{
   this.setHandlers(_symbol,
                    _period,
                    this.RSIConfigs.getAveragePeriod(),
                    this.RSIConfigs.getAppliedPrice());

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RSI::sortIndicators(string           _symbol,
                         ENUM_TIMEFRAMES  _period,
                         int              _amountCopy)
{
   ////////////////////////////////////////////////
   // Sort the price of the shorter MA downwards // 
   ////////////////////////////////////////////////
   CopyBuffer(this.handleAveragePeriod,
              0,
              0,
              _amountCopy,
              this.averagePeriodArray);
              
   ArraySetAsSeries(this.averagePeriodArray,
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
void RSI::getFeedBack(string           _symbol,
                      ENUM_TIMEFRAMES  _period,
                      datetime         _locked_bar_time)
{
   this.sortIndicators(_symbol,
                       _period,
                       1);
   
   //////////////////////////////////////
   // Restrictions on position opening //
   //////////////////////////////////////
   
   // A position has already been opened on the current bar
   if(_locked_bar_time >= (this.timeArray[0]))
   { 
      this.feedbackType = DO_NOTHING;
   }
   /*
   //////////////////////////////
   // Check for a Golden Cross //
   //////////////////////////////
   else if((this.shortPeriodArray[0] > this.longPeriodArray[0]) && 
           (this.shortPeriodArray[1] < this.longPeriodArray[1]))
   {
      this.feedbackType = BUY;
   }
   
   /////////////////////////////
   // Check for a Death Cross //
   /////////////////////////////
   else if((this.shortPeriodArray[0] < this.longPeriodArray[0]) && 
           (this.shortPeriodArray[1] > this.longPeriodArray[1]))
   {
      this.feedbackType = SELL;
   }
   */
   else 
   {
      this.feedbackType = DO_NOTHING;
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RSI::informUser(bool _successful)
{
   switch(_successful)
   {
      case true:
         break;
         
      case false:
         Print("Failed to create a handler for the Relative Strenght Index Indicator!"
               "\nError = ", GetLastError());
   
         ExpertRemove();
      
         break;
         
      default:
         break;
   }

   return;
}