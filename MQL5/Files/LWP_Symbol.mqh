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
      SymbolStruct                  symbolArray[CHARTS_MAX];
      
      AGRESSIDADE_OPERACOES         cunning;
      
      SYMBOL_GROUP                  symbolGroup;
      
#ifdef BOLLINGER_BANDS
      Bollinger_Bands_Configuration bollingerBands;
#endif
   
   protected:
      bool isSymbolInMarketWatch(string f_Symbol);
      
      bool checkWetherChartIsSync(string symbolName);
   
   public:
      LWP_Symbol(AGRESSIDADE_OPERACOES cunning,
                 SYMBOL_GROUP          symbolGroup);
      
      ~LWP_Symbol();
      
      void                    setCunning(AGRESSIDADE_OPERACOES value) { this.cunning = value; }
      AGRESSIDADE_OPERACOES   getCunning(void) { return this.cunning; }
      
      void          setSymbolGroup(SYMBOL_GROUP value) { this.symbolGroup = value; }
      SYMBOL_GROUP  getSymbolGroup(void) { return this.symbolGroup; }
                           
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
                                      
      Bollinger_Bands_Configuration getBollingerBandsIndicator(void);
      
      void openBollingerBandsForDesiredPeriod(void);
#endif
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::LWP_Symbol(AGRESSIDADE_OPERACOES cunningInputValue,
                       SYMBOL_GROUP          symbolGroupInputValue)
{
   this.cunning      = cunningInputValue;
   this.symbolGroup  = symbolGroupInputValue;
   
   return;
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
   populaAtivosAcoesDayTrade(this.symbolArray);
   
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
   
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      if(this.symbolArray[i].permissionToTrade == false)
      {
         continue;
      }
      
      if(this.isSymbolInMarketWatch(this.symbolArray[i].symbolName) == false)
      {
         Print(this.symbolArray[i].symbolName," could not be found on the server!");
         
         ExpertRemove();
      }
      
      else
      {
         Comment(this.symbolArray[i].symbolName," is available and will be analysed!");
      }
   }
   
   ///////////////////////////////////////////////////////
   /// Check whether the symbol is used more than once ///
   ///////////////////////////////////////////////////////
   
   if(ArraySize(this.symbolArray) > 1)
   {
      for(int i = 0; i < (ArraySize(this.symbolArray) - 1); i++)
      {
         if(this.symbolArray[i].permissionToTrade == false)
         { 
            continue;
         }
         
         for(int j = (i + 1); j < ArraySize(this.symbolArray); j++)
         {
            if(this.symbolArray[i].permissionToTrade == false)
            { 
               continue;
            }
            
            if(this.symbolArray[i].symbolName == this.symbolArray[j].symbolName)
            {
               Print(this.symbolArray[i].symbolName," is used more than once!");
               
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
   
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(name == NULL)
      {
         return;
      }
   
      openedChartID = ChartOpen(name, period);
   
      if(openedChartID != 0)
      {
         this.checkWetherChartIsSync(name);
         
         this.symbolArray[i].symbolID = openedChartID;
         
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
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {   
      if(ChartClose(this.symbolArray[i].symbolID))
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
   
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      name           = this.symbolArray[i].symbolName;
      currentChartID = this.symbolArray[i].symbolID;
      
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
         
         this.symbolArray[i].symbolID = newChartID;
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
   
   for(int i = 0; i < (ArraySize(this.symbolArray) - 1); i++)
   {
      string name = this.symbolArray[i].symbolName;
         
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
      
      for(int i = 0; i < ArraySize(this.symbolArray); i++)
      {
         string name = this.symbolArray[i].symbolName;
      
         if(name == NULL)
         {
            return;
         }
         
         this.checkWetherChartIsSync(name);
       
         this.symbolArray[i].bbClass.setHandlers(name,
                                                 period,
                                                 movingAverage_Period,
                                                 horizontalShift,
                                                 standardDeviation);
         
         this.symbolArray[i].bbClass.setInfoFromChart(name);
      }
      
      return;
   }
                                         
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Bollinger_Bands_Configuration LWP_Symbol::getBollingerBandsIndicator(void)
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
