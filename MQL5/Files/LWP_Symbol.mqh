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
      ENUM_AGRESSIDADE_OPERACOES    cunning;
      
      ENUM_SYMBOL_GROUP             symbolGroup;
      
   protected:
      bool isSymbolInMarketWatch(string f_Symbol);
      
      bool checkWetherChartIsSync(string symbolName);
      
      void getFeedBackAcompanhamentoTendencia(void);
      
      void getFeedBackContraTendencia(void);
      
      void getFeedBackVolatilidade(void);
      
      void indicatorsAcompanhamentoTendencia(ENUM_MODUS_OPERANDIS _modus,
                                             int                  _i,
                                             int                  _j,
                                             string               _name,
                                             ENUM_TIMEFRAMES      _timeframe);
                                             
      void indicatorsContraTendencia(ENUM_MODUS_OPERANDIS   _modus,
                                     int                    _i,
                                     int                    _j,
                                     string                 _name,
                                     ENUM_TIMEFRAMES        _timeframe);
                                             
      void indicatorsVolatilidade(ENUM_MODUS_OPERANDIS   _modus,
                                  int                    _i,
                                  int                    _j,
                                  string                 _name,
                                  ENUM_TIMEFRAMES        _timeframe);                                                                              
   
   public:
      LWP_Symbol(ENUM_AGRESSIDADE_OPERACOES  cunning,
                 ENUM_SYMBOL_GROUP           symbolGroup,
                 ENUM_TIMEFRAMES             &timeFramesArray[]);
      
      ~LWP_Symbol();
      
      SymbolStruct                  symbolArray[CHARTS_MAX];
      
      ENUM_TIMEFRAMES               timeFrames[NUM_TIMEFRAMES];
      
      void                          setCunning(ENUM_AGRESSIDADE_OPERACOES value)    { this.cunning = value; }
      ENUM_AGRESSIDADE_OPERACOES    getCunning(void)                                { return this.cunning; }
      
      void                          setSymbolGroup(ENUM_SYMBOL_GROUP value)         { this.symbolGroup = value; }
      ENUM_SYMBOL_GROUP             getSymbolGroup(void)                            { return this.symbolGroup; }
                           
      bool checkForSymbolsInMarketWatch(void);
      
      void openCharts(ENUM_TIMEFRAMES period);
      
      void closeAllCharts(void);
      
      bool changeChartsPeriod(ENUM_TIMEFRAMES period);
      
      void openAllIndicators(void);
      
      void getFeedBackFromIndicators(ENUM_GRUPO_INDICADORES grupoIndicadores);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_Symbol::LWP_Symbol(ENUM_AGRESSIDADE_OPERACOES  cunningInputValue,
                       ENUM_SYMBOL_GROUP           symbolGroupInputValue,
                       ENUM_TIMEFRAMES             &timeFramesArray[])
{
   this.cunning      = cunningInputValue;
   this.symbolGroup  = symbolGroupInputValue;
   
   for(int i = 0; i < ArraySize(timeFramesArray); i++)
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
      Comment("We are trying to synchronize data. Please wait!");
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
      
         this.indicatorsAcompanhamentoTendencia(OPEN_INDICATOR,
                                                i,
                                                j,
                                                name, 
                                                timeframe);
                                                
         this.indicatorsContraTendencia(OPEN_INDICATOR,
                                        i,
                                        j,
                                        name,
                                        timeframe);
                                        
         this.indicatorsVolatilidade(OPEN_INDICATOR,
                                     i,j,
                                     name,
                                     timeframe);                                                                      
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::getFeedBackFromIndicators(ENUM_GRUPO_INDICADORES grupoIndicadores)
{
   switch(grupoIndicadores)
   {
      case ACOMPANHAMENTO_TENDENCIA:
         getFeedBackAcompanhamentoTendencia();
         
         break;
         
      case CONTRA_TENDENCIA:
         getFeedBackContraTendencia();
      
         break;
         
      case VOLATILIDADE:
         getFeedBackContraTendencia();
         
         break;
         
      default:
         break;
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::getFeedBackAcompanhamentoTendencia(void)
{
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(name == NULL)
      {
         break;
      }
       
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(this.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
      
         if(timeframe == PERIOD_CURRENT)
         {
            break;
         }
      
         this.indicatorsAcompanhamentoTendencia(GET_FEEDBACK,
                                                i,
                                                j,
                                                name,
                                                timeframe);
      }
   }

   return;
}
      
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+      
void LWP_Symbol::getFeedBackContraTendencia(void)
{
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(name == NULL)
      {
         break;
      }
       
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(this.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
      
         if(timeframe == PERIOD_CURRENT)
         {
            break;
         }
      
         this.indicatorsContraTendencia(GET_FEEDBACK,
                                        i,
                                        j,
                                        name,
                                        timeframe);
      }
   }
   
   return;
}
      
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+      
void LWP_Symbol::getFeedBackVolatilidade(void)
{
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(name == NULL)
      {
         break;
      }
       
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(this.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
      
         if(timeframe == PERIOD_CURRENT)
         {
            break;
         }
      
         this.indicatorsVolatilidade(GET_FEEDBACK,
                                     i,
                                     j,
                                     name,
                                     timeframe);
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+      
void LWP_Symbol::indicatorsAcompanhamentoTendencia(ENUM_MODUS_OPERANDIS _modus,
                                                   int                  _i,
                                                   int                  _j,
                                                   string               _name,
                                                   ENUM_TIMEFRAMES      _timeframe)
{
   for(int k = 0; k < ArraySize(indicadores_AcompanhamentoTendencia); k++)
   {
      switch(indicadores_AcompanhamentoTendencia[k])
      {
         case BANDAS_DE_BOLLINGER:
            if(_modus == OPEN_INDICATOR)
            {
               this.symbolArray[_i].BollingerBands[_j].openIndicator(_name,
                                                                     _timeframe);
            }
            
            else if(_modus == GET_FEEDBACK)
            {
               this.symbolArray[_i].BollingerBands[_j].getFeedBack(_name,
                                                                   _timeframe);
            }
               
            break;
               
         case MOVING_AVERAGE:
            if(_modus == OPEN_INDICATOR)
            {
               this.symbolArray[_i].MovingAverage[_j].openIndicator(_name,
                                                                    _timeframe);
            }
            
            else if(_modus == GET_FEEDBACK)
            {
               
            }
            
            break;      
               
         default:
            break;
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+      
void LWP_Symbol::indicatorsContraTendencia(ENUM_MODUS_OPERANDIS   _modus,
                                           int                    _i,
                                           int                    _j,
                                           string                 _name,
                                           ENUM_TIMEFRAMES        _timeframe)
{
   for(int k = 0; k < ArraySize(indicadores_ContraTendencia); k++)
   {
      switch(indicadores_ContraTendencia[k])
      {
         default:
            break;
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+                                       
void LWP_Symbol::indicatorsVolatilidade(ENUM_MODUS_OPERANDIS   _modus,
                                        int                    _i,
                                        int                    _j,
                                        string                 _name,
                                        ENUM_TIMEFRAMES        _timeframe)
{
   for(int k = 0; k < ArraySize(indicadores_Volatilidade); k++)
   {
      switch(indicadores_Volatilidade[k])
      {
         default:
            break;
      }
   }
   
   return;
}                            