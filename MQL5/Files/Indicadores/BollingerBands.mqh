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

struct Bollinger_Bands_Configuration
{
   uint              movingAverage_Period;
   
   int               horizontalShift;
   
   double            standardDeviation;
};

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
      
   protected:
   
   public:
      void     setHandlers(string              symbol,            // symbol name 
                           ENUM_TIMEFRAMES     period,            // period 
                           int                 bands_period,      // period for average line calculation 
                           int                 bands_shift,       // horizontal shift of the indicator 
                           double              deviation);        // number of standard deviations     
                           
      void     setInfoFromChart(string         symbol);                     
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
   CSymbolInfo symbolInfo;

   // Calculate data for the Lot
   // Set the name of the symbol for which the information will be obtained
   symbolInfo.Name(symbol);
   
   // Minimum and maximum volume size in trading operations
   this.minLot = symbolInfo.LotsMin();
   this.maxLot = symbolInfo.LotsMax();
   
   // Point value
   this.point = symbolInfo.Point();
   
   // Contract size
   this.contractSize = symbolInfo.ContractSize();
   
   // Set some additional parameters
   this.dealNumber      = 0;
   this.locked_bar_time = 0;

   return;
}
                                  
//+------------------------------------------------------------------+
