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
#include "..\IndicadoresConfigs\MovingAverageConfig.mqh"

class Moving_Average
{
   private:
      int      handleShortPeriod;
      int      handleMediumPeriod;
      int      handleLongPeriod;
      
      double   minLot;
      double   maxLot;
      double   point;
      double   contractSize;
      
      uint     dealNumber;
      
      datetime locked_bar_time;
      datetime timeArray[];
   
      void              setInfoFromChart(string _symbol);
      
      void              setHandlers(string               _symbol,
                                    ENUM_TIMEFRAMES      _period,       
                                    uint                 _shortPeriod,
                                    uint                 _mediumPeriod,
                                    uint                 _longPeriod, 
                                    int                  _Shift,
                                    ENUM_MA_METHOD       _method,
                                    ENUM_APPLIED_PRICE   _applied_price);
      
   protected:
   
   public:
      Moving_Average_Configuration MovingAverageConfigs;
      
      void              openIndicator(string           _symbol,
                                      ENUM_TIMEFRAMES  _period);
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
   this.handleMediumPeriod  = iMA(_symbol,
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
   }
   
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
void Moving_Average::setInfoFromChart(string _symbol)
{
   CSymbolInfo    _symbolInfo;

   // Calculate data for the Lot
   // Set the name of the symbol for which the information will be obtained
   _symbolInfo.Name(_symbol);
   
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

   this.setInfoFromChart(_symbol);

   return;
}