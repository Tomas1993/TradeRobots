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

#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

#include "..\Configs.mqh"
#include "..\IndicadoresConfigs\BollingerBandsConfig.mqh"

class Bollinger_Bands
{
   private:
      int      handle_High;
      int      handle_Low;
      
      double   minLot;
      double   maxLot;
      double   point;
      double   contractSize;
      
      uint     dealNumber;
      
      datetime locked_bar_time;
      datetime timeArray[];
      
      double   upperBandHigh[];
      double   upperBandLow[];
      double   lowerBandHigh[];
      double   lowerBandLow[];
      
   protected:
   
   public:
      Bollinger_Bands_Configuration BollingerBandsConfigs;
   
      void     setHandlers(string              symbol,            // symbol name 
                           ENUM_TIMEFRAMES     period,            // period 
                           int                 bands_period,      // period for average line calculation 
                           int                 bands_shift,       // horizontal shift of the indicator 
                           double              deviation);        // number of standard deviations     
                           
      void     setInfoFromChart(string         symbol);          
      
      void     openBollingerBands(string           _symbol,
                                  ENUM_TIMEFRAMES  _period);     
                                  
      void     getFeedBack(string           _symbol,
                           ENUM_TIMEFRAMES  _period);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bollinger_Bands::setHandlers(string              symbol,
                                  ENUM_TIMEFRAMES     period,       
                                  int                 bands_period, 
                                  int                 bands_shift,  
                                  double              deviation)
{
   //////////////////////////////////
   /// First, based on High Price ///
   //////////////////////////////////
   this.handle_High = iBands(symbol,
                             period,
                             bands_period,
                             bands_shift,
                             deviation,
                             PRICE_HIGH);
                     
   if(this.handle_High < 0)
   {
      Print("Failed to create a handle for Bollinger Bands based on High prices for ", symbol, " . Handle = ", INVALID_HANDLE,
            "\n Error = ", GetLastError());
   
      ExpertRemove();
   }
   
   //////////////////////////////////
   /// Second, based on Low Price ///
   //////////////////////////////////
   this.handle_Low = iBands(symbol,
                            period,
                            bands_period,
                            bands_shift,
                            deviation,
                            PRICE_LOW);
                                         
   if(this.handle_Low < 0)
   {
      Print("Failed to create a handle for Bollinger Bands based on Low prices for ", symbol, " . Handle = ", INVALID_HANDLE,
            "\n Error = ", GetLastError());
   
      ExpertRemove();
   }
         
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bollinger_Bands::setInfoFromChart(string symbol)
{
   CSymbolInfo    _symbolInfo;

   // Calculate data for the Lot
   // Set the name of the symbol for which the information will be obtained
   _symbolInfo.Name(symbol);
   
   // Minimum and maximum volume size in trading operations
   this.minLot = _symbolInfo.LotsMin();
   this.maxLot = _symbolInfo.LotsMax();
   
   // Point value
   this.point = _symbolInfo.Point();
   
   // Contract size
   this.contractSize = _symbolInfo.ContractSize();
   
   // Set some additional parameters
   this.dealNumber      = 0;
   this.locked_bar_time = 0;

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bollinger_Bands::openBollingerBands(string           _symbol,
                                         ENUM_TIMEFRAMES  _period)
{
   this.setHandlers(_symbol,
                    _period,
                    this.BollingerBandsConfigs.getMovingAveragePeriod(),
                    this.BollingerBandsConfigs.getHorizontalShift(),
                    this.BollingerBandsConfigs.getStandardDeviation());

   this.setInfoFromChart(_symbol);

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bollinger_Bands::getFeedBack(string           _symbol,
                                  ENUM_TIMEFRAMES  _period)
{
   CSymbolInfo    _symbolInfo;
   CPositionInfo  _positionInfo;
   CTrade         _trade;
   
   double Ask_price;
   double Bid_price;
   double OrderLot = 0;
   
   ///////////////////////////////////////////////////////////////////
   // Upper band of Bollinger Bands calculated based on High prices //
   ///////////////////////////////////////////////////////////////////
   if(CopyBuffer(this.handle_High,
                 UPPER_BAND,
                 this.BollingerBandsConfigs.getHorizontalShift(),
                 1,
                 this.upperBandHigh) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.upperBandHigh,
                    true);
   
   //////////////////////////////////////////////////////
   // Lower band of BB calculated based on High prices //
   //////////////////////////////////////////////////////
   if(CopyBuffer(this.handle_High,
                 LOWER_BAND,
                 this.BollingerBandsConfigs.getHorizontalShift(),
                 1,
                 this.lowerBandHigh) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.lowerBandHigh,
                    true);
                    
   /////////////////////////////////////////////////////
   // Upper band of BB calculated based on Low prices //
   /////////////////////////////////////////////////////
   if(CopyBuffer(this.handle_Low,
                 UPPER_BAND,
                 this.BollingerBandsConfigs.getHorizontalShift(),
                 1,
                 this.upperBandLow) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.upperBandLow,
                    true);
   
   /////////////////////////////////////////////////////
   // Lower band of BB calculated based on Low prices //
   /////////////////////////////////////////////////////
   if(CopyBuffer(this.handle_Low,
                 LOWER_BAND,
                 this.BollingerBandsConfigs.getHorizontalShift(),
                 1,
                 this.lowerBandLow) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.lowerBandLow,
                    true);

   /////////////////////////////////////
   // Opening time of the current bar //
   ///////////////////////////////////// 
   if(CopyTime(_symbol,
               _period,
               0,
               1,
               this.timeArray) <= 0)
   {
      return;  // terminate the current FeedBack
   }
   
   ArraySetAsSeries(this.timeArray,
                    true);         

   /////////////////////////
   // Closing a Position ///
   /////////////////////////
   _symbolInfo.Name(_symbol);
   _symbolInfo.RefreshRates();
   
   Ask_price = _symbolInfo.Ask();
   Bid_price = _symbolInfo.Bid();
   
   if(PositionSelect(_symbol))
   {
      ////////////////////////////
      // Closing a BUY position //
      ////////////////////////////
      if(_positionInfo.PositionType() == POSITION_TYPE_BUY)
      {
         if((Bid_price >= this.lowerBandHigh[0]) || (this.dealNumber == 0))
         {
            if(!_trade.PositionClose(_symbol))
            {
               Print("Failed to close the Buy ", _symbol, " position. Code = ", _trade.ResultRetcode(),
                     " (", _trade.ResultRetcodeDescription(), ")");
                  
               return;
            }
            
            else
            {
               Print("The Buy ", _symbol, " position closed successfully. Code = ", _trade.ResultRetcode(),
                     " (", _trade.ResultRetcodeDescription(), ")");
                  
               return;
            }
         }
      }
      
      /////////////////////////////
      // Closing a SELL position //
      /////////////////////////////
      if(_positionInfo.PositionType() == POSITION_TYPE_SELL)
      {
         if((Ask_price <= this.upperBandLow[0]) || (this.dealNumber == 0))
         {
            if(!_trade.PositionClose(_symbol))
            {
               Print("Failed to close the Sell ", _symbol, " position. Code = ", _trade.ResultRetcode(),
                     " (", _trade.ResultRetcodeDescription(), ")");
               
               return; 
            }
            
            else
            {
               Print("The Sell ", _symbol, " position closed successfully. Code = ", _trade.ResultRetcode(),
                     " (", _trade.ResultRetcodeDescription(), ")");
                  
               return; 
            }
         }
      }
   }
   
   //////////////////////////////////////
   // Restrictions on position opening //
   //////////////////////////////////////
   
   // Price is in the position closing area
   if((Bid_price >= this.lowerBandHigh[0]) && (Ask_price <= this.upperBandLow[0]))
   {
      this.dealNumber = 0;
      
      return;
   }
   
   // A position has already been opened on the current bar
   if(this.locked_bar_time >= this.timeArray[0])
   { 
      return;
   }
   
   ////////////////////////
   // Opening a Position //
   ////////////////////////
   _symbolInfo.Name(_symbol);
   _symbolInfo.RefreshRates();
   
   Ask_price = _symbolInfo.Ask();
   Bid_price = _symbolInfo.Bid();
   
   ///////////////
   // For a Buy //
   ///////////////
   if(Ask_price <= this.lowerBandLow[0])
   {
      // Determine the current deal number 
      this.dealNumber++;
      
      // Calculate the lot
      OrderLot = 100;
      
      // Execute the Deal
      if(!_trade.Buy(OrderLot, 
                     _symbol))
      {
         // If the Buy is unsuccessful, decrease the deal number by 1
         this.dealNumber--;
            
         Print("The Buy ", _symbol, " has been unsuccessful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
               
         return;
      }
      
      else
      {
         // Save the current time to block the bar for trading
         this.locked_bar_time = TimeCurrent();
         
         Print("The Buy ", _symbol, " has been successful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
         
         return;
      }
   }
   
   ////////////////
   // For a Sell //
   ////////////////
   if(Bid_price >= this.upperBandHigh[0])
   {
      // Determine the current deal number 
      this.dealNumber++;
      
      // Calculate the lot
      OrderLot = 100;
      
      // Execute the Deal
      if(!_trade.Sell(OrderLot, 
                      _symbol))
      {
         // If the Sell is unsuccessful, decrease the deal number by 1
         this.dealNumber--;
            
         Print("The Sell ", _symbol, " has been unsuccessful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
               
         return;
      }
      
      else
      {
         // Save the current time to block the bar for trading
         this.locked_bar_time = TimeCurrent();
         
         Print("The Buy ", _symbol, " has been successful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
         
         return;
      }
   }
   
   return;
}