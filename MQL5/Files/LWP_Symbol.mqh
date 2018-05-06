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
                                  
      void getFeedBackFromIndicators(ENUM_GRUPO_INDICADORES _grupoIndicadores,
                                     int                    _i,
                                     string                 _name);                            
   
   public:
      LWP_Symbol(ENUM_AGRESSIDADE_OPERACOES  cunning,
                 ENUM_SYMBOL_GROUP           symbolGroup,
                 ENUM_TIMEFRAMES             &timeFramesArray[]);
      
      ~LWP_Symbol();
      
      SymbolStruct                  symbolArray[];
      
      ENUM_TIMEFRAMES               timeFrames[];
      
      void                          setCunning(ENUM_AGRESSIDADE_OPERACOES value)    { this.cunning = value; }
      ENUM_AGRESSIDADE_OPERACOES    getCunning(void)                                { return this.cunning; }
      
      void                          setSymbolGroup(ENUM_SYMBOL_GROUP value)         { this.symbolGroup = value; }
      ENUM_SYMBOL_GROUP             getSymbolGroup(void)                            { return this.symbolGroup; }
                           
      bool initialConfigs(void);
      
      void openAllIndicators(void);
      
      void getFeedBackFromIndicatorsAndExecuteDeal(void);
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
   
   ArrayResize(this.timeFrames,
               ArraySize(timeFramesArray));
   
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
      if(f_Symbol == SymbolName(s,
                                false))
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
bool LWP_Symbol::initialConfigs(void)
{
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      ArrayResize(this.symbolArray[i].BollingerBands,
                  ArraySize(this.timeFrames));
                  
      ArrayResize(this.symbolArray[i].MovingAverage,
                  ArraySize(this.timeFrames));            
   }
   
   ////////////////////////////////////////////////
   /// Check for the symbol in the Market Watch ///
   ////////////////////////////////////////////////

   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
   
      if(this.isSymbolInMarketWatch(name) == false)
      {
         Print(this.symbolArray[i].symbolName," could not be found on the server!");
         
         ExpertRemove();
      }
      
      else
      {
         // Configure some info. from the symbols charts
         this.symbolArray[i].setInfoFromChart();
      
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
         string name = this.symbolArray[i].symbolName;
      
         for(int j = (i + 1); j < ArraySize(this.symbolArray); j++)
         {
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
void LWP_Symbol::openAllIndicators(void)
{
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
       
      this.checkWetherChartIsSync(name);
        
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(this.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
      
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
void LWP_Symbol::getFeedBackFromIndicatorsAndExecuteDeal(void)
{
   // Percorre o vetor de ativos
   for(int i = 0; i < ArraySize(this.symbolArray); i++)
   {
      string name = this.symbolArray[i].symbolName;
      
      getFeedBackFromIndicators(ACOMPANHAMENTO_TENDENCIA,
                                i,
                                name);
      
      getFeedBackFromIndicators(CONTRA_TENDENCIA,
                                i,
                                name);
      
      getFeedBackFromIndicators(VOLATILIDADE,
                                i,
                                name);
                                
      // Execute Deal (or not)                          
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LWP_Symbol::getFeedBackFromIndicators(ENUM_GRUPO_INDICADORES _grupoIndicadores,
                                           int                    _i,
                                           string                 _name)
{
   // Varre o vetor de periodos
   for(int j = 0; j < ArraySize(this.timeFrames); j++)
   {
      ENUM_TIMEFRAMES timeframe = this.timeFrames[j];
   
      switch(_grupoIndicadores)
      {
         case ACOMPANHAMENTO_TENDENCIA:
            this.indicatorsAcompanhamentoTendencia(GET_FEEDBACK,
                                                   _i,
                                                   j,
                                                   _name,
                                                   timeframe);
            
            break;
            
         case CONTRA_TENDENCIA:
            this.indicatorsContraTendencia(GET_FEEDBACK,
                                           _i,
                                           j,
                                           _name,
                                           timeframe);
         
            break;
            
         case VOLATILIDADE:
            this.indicatorsVolatilidade(GET_FEEDBACK,
                                        _i,
                                        j,
                                        _name,
                                        timeframe);
            
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
void LWP_Symbol::indicatorsAcompanhamentoTendencia(ENUM_MODUS_OPERANDIS _modus,
                                                   int                  _i,
                                                   int                  _j,
                                                   string               _name,
                                                   ENUM_TIMEFRAMES      _timeframe)
{
   for(int k = 0; k < ArraySize(acompanhamentoTendenciaIndicators); k++)
   {
      switch(acompanhamentoTendenciaIndicators[k])
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
               this.symbolArray[_i].MovingAverage[_j].getFeedBack(_name,
                                                                  _timeframe);
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
   for(int k = 0; k < ArraySize(volatilityIndicators); k++)
   {
      switch(volatilityIndicators[k])
      {
         default:
            break;
      }
   }
   
   return;
}