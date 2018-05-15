//+------------------------------------------------------------------+
//|                                                 SymbolStruct.mqh |
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

#include "Configs.mqh"
#include "..\Files\Indicadores\BollingerBands.mqh"
#include "..\Files\Indicadores\MovingAverage.mqh"
#include "..\Files\Indicadores\RelativeStrengthIndex.mqh"

struct SymbolStruct
{
   public:
      string                  symbolName;
      
      long                    symbolID;
      
      uchar                   symbolWeight;
      
      double                  minLot;
      double                  maxLot;
      double                  point;
      double                  contractSize;
      
      datetime                locked_bar_time;
      
      uint                    dealNumber;
      
      Bollinger_Bands         BollingerBands[];
      
      Moving_Average          MovingAverage[];
      
      RSI                     RelativeStrengthIndex[];
      
      void                    setInfoFromChart(void);
      
      void                    analyseFeedBack(
                                 ENUM_FEEDBACK_TYPE&        _feedbackType,
                                 int                        _sizeTimeFrames
                              );
      
      void                    executeDeal(
                                 ENUM_FEEDBACK_TYPE         _feedback
                              );
                                 
   private:
      void                    analyseFeedBackAcompanhamentoTendencia(
                                 ENUM_FEEDBACK_TYPE&        _feedbackType,
                                 int                        _sizeTimeFrames,
                                 bool                       _firstAnalysis
                              );
      
      void                    analyseFeedBackContraTendencia(
                                 ENUM_FEEDBACK_TYPE&        _feedbackType,
                                 int                        _sizeTimeFrames,
                                 bool                       _firstAnalysis
                              );
      
      void                    analyseFeedBackVolatilidade(
                                 ENUM_FEEDBACK_TYPE&        _feedbackType,
                                 int                        _sizeTimeFrames,
                                 bool                       _firstAnalysis
                              );
      
      double                  calculateLot(
                                 ENUM_FEEDBACK_TYPE         _feedback
                              );
      
      double                  calculatePrice(
                                 ENUM_FEEDBACK_TYPE         _feedback
                              );
      
      double                  calculateStopLoss(
                                 ENUM_FEEDBACK_TYPE         _feedback
                              );
      
      double                  calculateStopGain(
                                 ENUM_FEEDBACK_TYPE         _feedback
                              );
                              
      void                    informUserTrade(
                                 bool                       _tradeSuccessful,
                                 CTrade&                    _trade
                              );
                     
      void                    sumFeedBacks(
                                 ENUM_FEEDBACK_TYPE&        _feedback,
                                 ENUM_FEEDBACK_TYPE         _feedbackAux
                              );                        
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::setInfoFromChart(void)
{
   CSymbolInfo    _symbolInfo;
   
   // Set the name of the symbol for which the information will be obtained
   _symbolInfo.Name(this.symbolName);

   // Minimum and maximum volume size in trading operations
   this.minLot          = _symbolInfo.LotsMin();
   this.maxLot          = _symbolInfo.LotsMax();
   
   // Point value
   this.point           = _symbolInfo.Point();
   
   // Contract size
   this.contractSize    = _symbolInfo.ContractSize();
   
   // Set some additional parameters
   this.dealNumber      = 0;
   this.locked_bar_time = 0;

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBack(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                   int                   _sizeTimeFrames)
{
   ENUM_FEEDBACK_TYPE   feedBackType_AcompanhamentoTendencia;
   ENUM_FEEDBACK_TYPE   feedBackType_ContraTendencia;
   ENUM_FEEDBACK_TYPE   feedBackType_Volatilidade;

   if(ArraySize(acompanhamentoTendenciaIndicators) > 0)
   {
      this.analyseFeedBackAcompanhamentoTendencia(feedBackType_AcompanhamentoTendencia,
                                                  _sizeTimeFrames,
                                                  true);
      
      _feedbackType = feedBackType_AcompanhamentoTendencia;
   }
   
   if(ArraySize(indicadores_ContraTendencia) > 0)
   {
      if(ArraySize(acompanhamentoTendenciaIndicators) > 0)
      {
         this.analyseFeedBackContraTendencia(feedBackType_ContraTendencia,
                                             _sizeTimeFrames,
                                             false);
         
         this.sumFeedBacks(_feedbackType,
                           feedBackType_ContraTendencia);
      }
      
      else
      {
         this.analyseFeedBackContraTendencia(feedBackType_ContraTendencia,
                                             _sizeTimeFrames,
                                             true);
         
         _feedbackType = feedBackType_ContraTendencia;
      }
   }
   
   if(ArraySize(volatilityIndicators) > 0)
   {
      if(ArraySize(volatilityIndicators) > 0)
      {   
         this.analyseFeedBackVolatilidade(feedBackType_Volatilidade,
                                          _sizeTimeFrames,
                                          false);
         
         this.sumFeedBacks(_feedbackType,
                           feedBackType_Volatilidade);
      }
      
      else
      {
         this.analyseFeedBackVolatilidade(feedBackType_Volatilidade,
                                          _sizeTimeFrames,
                                          true);
         
         _feedbackType = feedBackType_Volatilidade;
      }
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackAcompanhamentoTendencia(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                                          int                   _sizeTimeFrames,
                                                          bool                  _firstAnalysis)
{
   ENUM_FEEDBACK_TYPE   feedbackTypeAux;

   // Varre o vetor de Indicadores de Acompanhamento de Tendencia
   for(int i = 0; i < ArraySize(acompanhamentoTendenciaIndicators); i++)
   {
      // Todos os indicadores possuem o mesmo tamanho (referente aos periodos de cada um)
      for(int j = 0; j < _sizeTimeFrames; j++)
      {
         switch(acompanhamentoTendenciaIndicators[i])
         {
            case BOLLINGER_BANDS:
               feedbackTypeAux   = this.BollingerBands[j].getFeedBackType();
               
               break;
               
            case MOVING_AVERAGE:
               feedbackTypeAux   = this.MovingAverage[j].getFeedBackType();
               
               break;      
               
            default:
               feedbackTypeAux   = DO_NOTHING;
            
               break;
         }
         
         if(_firstAnalysis)
         {
            _feedbackType  = feedbackTypeAux;
            
            _firstAnalysis = false;
         }
         
         else
         {
            this.sumFeedBacks(_feedbackType,
                              feedbackTypeAux);
         }
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackContraTendencia(ENUM_FEEDBACK_TYPE&   _feedbackType, 
                                                  int                   _sizeTimeFrames,
                                                  bool                  _firstAnalysis)
{
   ENUM_FEEDBACK_TYPE   feedbackTypeAux;
   
   // Varre o vetor de Indicadores de Acompanhamento de Tendencia
   for(int i = 0; i < ArraySize(indicadores_ContraTendencia); i++)
   {
      // Todos os indicadores possuem o mesmo tamanho (referente aos periodos de cada um)
      for(int j = 0; j < _sizeTimeFrames; j++)
      {
         switch(indicadores_ContraTendencia[i])
         {
            case RELATIVE_STRENGTH_INDEX:
               feedbackTypeAux   = this.RelativeStrengthIndex[j].getFeedBackType();
               
               break;
               
            default:
               feedbackTypeAux   = DO_NOTHING;
            
               break;
         }
         
         if(_firstAnalysis)
         {
            _feedbackType  = feedbackTypeAux;
            
            _firstAnalysis = false;
         }
         
         else
         {
            this.sumFeedBacks(_feedbackType,
                              feedbackTypeAux);
         }
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackVolatilidade(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                               int                   _sizeTimeFrames,
                                               bool                  _firstAnalysis)
{
   ENUM_FEEDBACK_TYPE   feedbackTypeAux;
   
   // Varre o vetor de Indicadores de Acompanhamento de Tendencia
   for(int i = 0; i < ArraySize(volatilityIndicators); i++)
   {
      // Todos os indicadores possuem o mesmo tamanho (referente aos periodos de cada um)
      for(int j = 0; j < _sizeTimeFrames; j++)
      {
         switch(volatilityIndicators[i])
         { 
            default:
               feedbackTypeAux   = DO_NOTHING;
            
               break;
         }
         
         if(_firstAnalysis)
         {
            _feedbackType  = feedbackTypeAux;
            
            _firstAnalysis = false;
         }
         
         else
         {
            this.sumFeedBacks(_feedbackType,
                              feedbackTypeAux);
         }
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::executeDeal(ENUM_FEEDBACK_TYPE _feedback)
{
   CTrade         _trade;
   
   bool           tradeReturn = false;
   
   double         OrderLot    = 0.0;
   double         StopLoss    = 0.0;
   double         StopGain    = 0.0;
   double         Price       = 0.0;
   
   if(this.locked_bar_time >= TimeCurrent())
   {
      return;
   }
   
   // Calculate the lot
   OrderLot = this.calculateLot(_feedback);
   
   // Calculate Order Price
   Price    = this.calculatePrice(_feedback);
   
   // Calculate Stop Loss
   StopLoss = this.calculateStopLoss(_feedback);
   
   // Calculate Stop Gain
   StopGain = this.calculateStopGain(_feedback);
   
   switch(_feedback)
   {
      case BUY:
         // Determine the current deal number 
         this.dealNumber++;
         
         // Execute the Deal
         tradeReturn = _trade.Buy(OrderLot, 
                                  this.symbolName,
                                  Price,
                                  StopLoss,
                                  StopGain);
                                  
         this.informUserTrade(tradeReturn,
                              _trade);
                              
         break;
         
      case SELL:
         // Determine the current deal number 
         this.dealNumber++;
         
         // Execute the Deal
         tradeReturn = _trade.Sell(OrderLot, 
                                   this.symbolName,
                                   Price,
                                   StopLoss,
                                   StopGain);
                                  
         this.informUserTrade(tradeReturn,
                              _trade);
      
         break;
         
      case DO_NOTHING:    
      default:
         break;
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbolStruct::calculateLot(ENUM_FEEDBACK_TYPE _feedback)
{
   return this.minLot;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbolStruct::calculatePrice(ENUM_FEEDBACK_TYPE _feedback)
{
   CSymbolInfo    _symbolInfo;
   
   double         Ask_price;
   double         Bid_price;
   
   ////////////////////////
   // Opening a Position //
   ////////////////////////
   
   _symbolInfo.Name(this.symbolName);
   _symbolInfo.RefreshRates();
   
   Ask_price = _symbolInfo.Ask();
   Bid_price = _symbolInfo.Bid();
   
   return 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbolStruct::calculateStopLoss(ENUM_FEEDBACK_TYPE _feedback)
{
   return 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SymbolStruct::calculateStopGain(ENUM_FEEDBACK_TYPE _feedback)
{
   return 0.0;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::informUserTrade(bool                     _tradeSuccessful,
                                   CTrade&                  _trade)
{
   switch(_tradeSuccessful)
   {
      case true:
         // Save the current time to block the bar for trading
         this.locked_bar_time = TimeCurrent();
            
         Print("The Deal for ", this.symbolName, " has been successful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
                  
         break;
         
      case false:
         // If the Buy is unsuccessful, decrease the deal number by 1
         this.dealNumber--;
            
         Print("The Deal for ", this.symbolName, " has been unsuccessful. Code = ", _trade.ResultRetcode(),
               " (", _trade.ResultRetcodeDescription(), ")");
                  
         break;
         
      default:
         break;   
   }

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::sumFeedBacks(ENUM_FEEDBACK_TYPE&   _feedback,
                                ENUM_FEEDBACK_TYPE    _feedbackAux)
{
   if(_feedback != _feedbackAux)
   {
      _feedback = DO_NOTHING;
   }
   
   return;
}                                