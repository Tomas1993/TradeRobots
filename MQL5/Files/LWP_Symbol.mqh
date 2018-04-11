//+------------------------------------------------------------------+
//|                                                       Symbol.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\SymbolInfo.mqh>

#include "SymbolStruct.mqh"
#include "Ativos.mqh"
#include "Configs.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LWP_Symbol
{
   private:
      SymbolStruct      acoes[CHARTS_MAX];
      
#ifdef BOLLINGER_BANDS
      Bollinger_Bands   bollingerBands;
#endif
   
   protected:
      bool isSymbolInMarketWatch(string f_Symbol);
      
      bool checkWetherChartIsSync(string symbolName);
   
   public:
      LWP_Symbol();
      
      ~LWP_Symbol();
                           
      void populateAcoesDayTrade(void);
      
      bool checkForSymbolsInMarketWatch(void);
      
      void openCharts(ENUM_TIMEFRAMES period);
      
      void closeAllCharts(void);
      
      bool changeChartsPeriod(ENUM_TIMEFRAMES period);
      
      void getInfoOfEverySymbol(void);
      
#ifdef BOLLINGER_BANDS
      void setBollingerBandsIndicator(ENUM_TIMEFRAMES period,
                                      uint            movingAverage_Period, 
                                      int             horizontalShift, 
                                      double          standardDeviation);
                                      
      Bollinger_Bands getBollingerBandsIndicator(void);
      
      void openBollingerBandsForDesiredPeriod(void);
#endif
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::LWP_Symbol()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::~LWP_Symbol()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::populateAcoesDayTrade(void)
{
   populaAtivosAcoesDayTrade(this.acoes);
   
   return;
}

//+------------------------------------------------------------------+
//| The IsSymbolInMarketWatch() function                             |
//+------------------------------------------------------------------+
bool LWP_Symbol::isSymbolInMarketWatch(string f_Symbol)
{
   int totalSymbols = SymbolsTotal(false);
   
   for(int s = 0; s < totalSymbols; s++)
   {
      if(f_Symbol == SymbolName(s,false))
      {
         return true;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LWP_Symbol::checkWetherChartIsSync(string symbolName)
{
   while(SymbolIsSynchronized(symbolName) == false)
   {
      //Comment("We are trying to synchronize data. Please wait!");
   }
         
   return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LWP_Symbol::checkForSymbolsInMarketWatch(void)
{
   ////////////////////////////////////////////////
   /// Check for the symbol in the Market Watch ///
   ////////////////////////////////////////////////
   
   for(int i = 0; i < ArraySize(this.acoes); i++)
   {
      if(this.acoes[i].permissionToTrade == false)
      {
         continue;
      }
      
      if(this.isSymbolInMarketWatch(this.acoes[i].symbolName) == false)
      {
         Print(this.acoes[i].symbolName," could not be found on the server!");
         
         ExpertRemove();
      }
      
      else
      {
         Comment(this.acoes[i].symbolName," is available and will be analysed!");
      }
   }
   
   ///////////////////////////////////////////////////////
   /// Check whether the symbol is used more than once ///
   ///////////////////////////////////////////////////////
   
   if(ArraySize(this.acoes) > 1)
   {
      for(int i = 0; i < (ArraySize(this.acoes) - 1); i++)
      {
         if(this.acoes[i].permissionToTrade == false)
         { 
            continue;
         }
         
         for(int j = (i + 1); j < ArraySize(this.acoes); j++)
         {
            if(this.acoes[i].permissionToTrade == false)
            { 
               continue;
            }
            
            if(this.acoes[i].symbolName == this.acoes[j].symbolName)
            {
               Print(this.acoes[i].symbolName," is used more than once!");
               
               ExpertRemove();
            }
         }
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::openCharts(ENUM_TIMEFRAMES period)
{
   long openedChartID;
   
   for(int i = 0; i < ArraySize(this.acoes); i++)
   {
      string name = this.acoes[i].symbolName;
   
      if(name == NULL)
      {
         return;
      }
   
      openedChartID = ChartOpen(name, period);
   
      if(openedChartID != 0)
      {
         this.checkWetherChartIsSync(name);
         
         this.acoes[i].symbolID = openedChartID;
         
         SymbolSelect(name, 1);
      }
      
      else
      {
         Print(name, " Chart could not be opened! Exiting EA");
         
         ExpertRemove();
      }
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::closeAllCharts(void)
{
   for(int i = 0; i < ArraySize(this.acoes); i++)
   {   
      if(ChartClose(this.acoes[i].symbolID))
      {         
         //Print("Chart successfully closed!");
      }
      
      else
      {
         Print("Chart could not be closed! Exiting EA");
         
         ExpertRemove();
      }
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LWP_Symbol::changeChartsPeriod(ENUM_TIMEFRAMES period)
{
   string name;
   long currentChartID;
   long newChartID;
   
   for(int i = 0; i < ArraySize(this.acoes); i++)
   {
      name           = this.acoes[i].symbolName;
      currentChartID = this.acoes[i].symbolID;
      
      if(name == NULL)
      {
         return false;
      }
      
      //newChartID  = ChartSetSymbolPeriod(currentChartID, name, period);
   
      ChartClose(currentChartID);
      
      newChartID = ChartOpen(name, period);
   
      if(newChartID != 0)
      {
         this.checkWetherChartIsSync(name);
         
         this.acoes[i].symbolID = newChartID;
      }
      
      else
      {
         Print(name, " Chart could not be opened! Exiting EA");
         
         ExpertRemove();
      }
   }

   return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::getInfoOfEverySymbol(void)
{
   MqlTick tick;
   
   for(int i = 0; i < (ArraySize(this.acoes) - 1); i++)
   {
      string name = this.acoes[i].symbolName;
         
      SymbolInfoTick(name, tick);
   
      Comment(name, "bid: ", tick.bid);
   }
         
   return;
}

#ifdef BOLLINGER_BANDS
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void LWP_Symbol::setBollingerBandsIndicator(ENUM_TIMEFRAMES period,
                                               uint            movingAverage_Period, 
                                               int             horizontalShift, 
                                               double          standardDeviation)
   {
      CSymbolInfo symbolInfo;
   
      this.bollingerBands.movingAverage_Period  = movingAverage_Period;
      this.bollingerBands.horizontalShift       = horizontalShift;
      
      if(standardDeviation > 0.0)
      {
         this.bollingerBands.standardDeviation     = standardDeviation;
      }
      
      else
      {
         Print("The standard deviation of Bollinger Bands must be more than 0.0");
         
         ExpertRemove();
      }
      
      //////////////////////////////////////////////
      /// Set indicator handles for every active ///
      //////////////////////////////////////////////
      
      for(int i = 0; i < ArraySize(this.acoes); i++)
      {
         string name = this.acoes[i].symbolName;
      
         if(name == NULL)
         {
            return;
         }
         
         this.checkWetherChartIsSync(name);
       
         //////////////////////////////////
         /// First, based on High Price ///
         //////////////////////////////////
         this.acoes[i].BB_Handle_High = iBands(name,
                                               period,
                                               movingAverage_Period,
                                               horizontalShift,
                                               standardDeviation,
                                               PRICE_HIGH);
                                               
         if(this.acoes[i].BB_Handle_High < 0)
         {
            Print("Failed to create a handle for Bollinger Bands based on High prices for ", name, " . Handle=",INVALID_HANDLE,
                  "\n Error=",GetLastError());
         
            ExpertRemove();
         }
         
         //////////////////////////////////
         /// Second, based on Low Price ///
         //////////////////////////////////
         this.acoes[i].BB_Handle_Low = iBands(name,
                                              period,
                                              movingAverage_Period,
                                              horizontalShift,
                                              standardDeviation,
                                              PRICE_LOW);
                                               
         if(this.acoes[i].BB_Handle_Low < 0)
         {
            Print("Failed to create a handle for Bollinger Bands based on Low prices for ", name, " . Handle=",INVALID_HANDLE,
                  "\n Error=",GetLastError());
         
            ExpertRemove();
         }
         
         // Calculate data for the Lot
         // Set the name of the symbol for which the information will be obtained
         symbolInfo.Name(name);
         
         // Minimum and maximum volume size in trading operations
         this.acoes[i].BB_MinLot = symbolInfo.LotsMin();
         this.acoes[i].BB_MaxLot = symbolInfo.LotsMax();
         
         // Point value
         this.acoes[i].BB_Point = symbolInfo.Point();
         
         // Contract size
         this.acoes[i].BB_ContractSize = symbolInfo.ContractSize();
         
         // Set some additional parameters
         this.acoes[i].BB_DealNumber   = 0;
         this.acoes[i].BB_Locked_bar_time = 0;
      }
      
      return;
   }
                                         
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Bollinger_Bands LWP_Symbol::getBollingerBandsIndicator(void)
   {
      return this.bollingerBands;
   }
   
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void LWP_Symbol::openBollingerBandsForDesiredPeriod(void)
   {
      for(int i = 0; i < ArraySize(timeFrames_AcoesDayTrade); i++)
      {
         this.setBollingerBandsIndicator(timeFrames_AcoesDayTrade[i],
                                         12,
                                         0,
                                         2.2);
      }
   
      return;
   }
#endif

//+------------------------------------------------------------------+
