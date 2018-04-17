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
#include "IndicadoresConfigs\BollingerBandsConfig.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LWP_Symbol : public Bollinger_Bands_Configuration
{
   private:
      AGRESSIDADE_OPERACOES         cunning;
      
      SYMBOL_GROUP                  symbolGroup;
      
      ENUM_TIMEFRAMES               timeFrames[NUM_TIMEFRAMES];
      
      //Bollinger_Bands_Configuration bollingerBands;
   
   protected:
      bool isSymbolInMarketWatch(string f_Symbol);
      
      bool checkWetherChartIsSync(string symbolName);
   
   public:
      LWP_Symbol(AGRESSIDADE_OPERACOES cunning,
                 SYMBOL_GROUP          symbolGroup,
                 ENUM_TIMEFRAMES       &timeFramesArray[]);
      
      ~LWP_Symbol();
      
      SymbolStruct            symbolArray[CHARTS_MAX];
      
      void                    setCunning(AGRESSIDADE_OPERACOES value)   { this.cunning = value; }
      AGRESSIDADE_OPERACOES   getCunning(void)                          { return this.cunning; }
      
      void                    setSymbolGroup(SYMBOL_GROUP value)        { this.symbolGroup = value; }
      SYMBOL_GROUP            getSymbolGroup(void)                      { return this.symbolGroup; }
                           
      bool checkForSymbolsInMarketWatch(void);
      
      void openCharts(ENUM_TIMEFRAMES period);
      
      void closeAllCharts(void);
      
      bool changeChartsPeriod(ENUM_TIMEFRAMES period);
      
      void openAllIndicators(void);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::LWP_Symbol(AGRESSIDADE_OPERACOES cunningInputValue,
                       SYMBOL_GROUP          symbolGroupInputValue,
                       ENUM_TIMEFRAMES       &timeFramesArray[])
{
   this.cunning      = cunningInputValue;
   this.symbolGroup  = symbolGroupInputValue;
   
   for(uint i = 0; i < ArraySize(timeFramesArray); i++)
   {
      this.timeFrames[i]   = timeFramesArray[i];
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::~LWP_Symbol()
{
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
void LWP_Symbol::openAllIndicators(void)
{
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(name == NULL)
      {
         break;
      }
       
      this.checkWetherChartIsSync(name);
        
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(this.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
      
         if(timeframe == PERIOD_CURRENT)
         {
            break;
         }
      
         // Open Bollinger Bands Indicator
         this.symbolArray[i].bbClass[j].openBollingerBands(name,
                                                           this.timeFrames[j],
                                                           this.getMovingAveragePeriod(),
                                                           this.getHorizontalShift(),
                                                           this.getStandardDeviation());
      }
   }
   
   return;
}