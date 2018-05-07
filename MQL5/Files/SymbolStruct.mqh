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

struct SymbolStruct
{
   public:
      string            symbolName;
      
      long              symbolID;
      
      uchar             symbolWeight;
      
      double            minLot;
      double            maxLot;
      double            point;
      double            contractSize;
      
      datetime          locked_bar_time;
      
      uint              dealNumber;
      
      Bollinger_Bands   BollingerBands[];
      
      Moving_Average    MovingAverage[];
      
      void              setInfoFromChart(void);
      
      void              analyseFeedBack(ENUM_FEEDBACK_TYPE& _feedbackType,
                                        double&             _feedbackForce);
      
      void              executeDeal(ENUM_FEEDBACK_TYPE _feedback,
                                    double             _feedbackForce);
                                 
   private:
      void              analyseFeedBackAcompanhamentoTendencia(ENUM_FEEDBACK_TYPE& _feedbackType,
                                                               double&             _feedbackForce);
      
      void              analyseFeedBackContraTendencia(ENUM_FEEDBACK_TYPE& _feedbackType,
                                                       double&             _feedbackForce);
      
      void              analyseFeedBackVolatilidade(ENUM_FEEDBACK_TYPE& _feedbackType,
                                                    double&             _feedbackForce);
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
                                   double&               _feedbackForce)
{
   ENUM_FEEDBACK_TYPE   feedBackType_AcompanhamentoTendencia;
   double               feedbackForce_AcompanhamentoTendencia;
   
   /*ENUM_FEEDBACK_TYPE   feedBackType_ContraTendencia;
   double               feedbackForce_ContraTendencia;
   
   ENUM_FEEDBACK_TYPE   feedBackType_Volatilidade;
   double               feedbackForce_Volatilidade;*/

   this.analyseFeedBackAcompanhamentoTendencia(feedBackType_AcompanhamentoTendencia,
                                               feedbackForce_AcompanhamentoTendencia);
   
   /*this.analyseFeedBackContraTendencia(feedBackType_ContraTendencia,
                                       feedbackForce_ContraTendencia);
   
   this.analyseFeedBackVolatilidade(feedBackType_Volatilidade,
                                    feedbackForce_Volatilidade);*/
              
   // TODO                                 
   _feedbackType = feedBackType_AcompanhamentoTendencia;                                 

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackAcompanhamentoTendencia(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                                          double&               _feedbackForce)
{
   // Varre o vetor referente as Medias Moveis
   for(int i = 0; i < ArraySize(this.MovingAverage); i++)
   {
      // TODO
      _feedbackType = this.MovingAverage[i].getFeedBackType();
   }
   
   // Varre o vetor referente as Bandas de Bollinger
   for(int i = 0; i < ArraySize(this.BollingerBands); i++)
   {
      //this.BollingerBands[i]
   }
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackContraTendencia(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                                  double&               _feedbackForce)
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::analyseFeedBackVolatilidade(ENUM_FEEDBACK_TYPE&   _feedbackType,
                                               double&               _feedbackForce)
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::executeDeal(ENUM_FEEDBACK_TYPE _feedback,
                               double             _feedbackForce)
{
   CSymbolInfo    _symbolInfo;
   CPositionInfo  _positionInfo;
   CTrade         _trade;
   
   double Ask_price;
   double Bid_price;
   double OrderLot = 0;
   
   ////////////////////////
   // Opening a Position //
   ////////////////////////
   
   _symbolInfo.Name(this.symbolName);
   _symbolInfo.RefreshRates();
   
   Ask_price = _symbolInfo.Ask();
   Bid_price = _symbolInfo.Bid();
   
   if(this.locked_bar_time >= TimeCurrent())
   {
      return;
   }
   
   switch(_feedback)
   {
      case BUY:
         // Determine the current deal number 
         this.dealNumber++;
         
         // Calculate the lot
         OrderLot = this.minLot;
         
         // Execute the Deal
         if(!_trade.Buy(OrderLot, 
                        this.symbolName))
         {
            // If the Buy is unsuccessful, decrease the deal number by 1
            this.dealNumber--;
               
            Print("The Buy ", this.symbolName, " has been unsuccessful. Code = ", _trade.ResultRetcode(),
                  " (", _trade.ResultRetcodeDescription(), ")");
                  
            return;
         }
         
         else
         {
            // Save the current time to block the bar for trading
            this.locked_bar_time = TimeCurrent();
            
            Print("The Buy ", this.symbolName, " has been successful. Code = ", _trade.ResultRetcode(),
                  " (", _trade.ResultRetcodeDescription(), ")");
            
            return;
         }
      
         break;
         
      case SELL:
         // Determine the current deal number 
         this.dealNumber++;
         
         // Calculate the lot
         OrderLot = this.minLot;
         
         // Execute the Deal
         if(!_trade.Sell(OrderLot, 
                         this.symbolName))
         {
            // If the Sell is unsuccessful, decrease the deal number by 1
            this.dealNumber--;
               
            Print("The Sell ", this.symbolName, " has been unsuccessful. Code = ", _trade.ResultRetcode(),
                  " (", _trade.ResultRetcodeDescription(), ")");
                  
            return;
         }
         
         else
         {
            // Save the current time to block the bar for trading
            this.locked_bar_time = TimeCurrent();
            
            Print("The Buy ", this.symbolName, " has been successful. Code = ", _trade.ResultRetcode(),
                  " (", _trade.ResultRetcodeDescription(), ")");
            
            return;
         }
      
         break;
         
      case DO_NOTHING:
         break;   
         
      default:
         break;
   }

   return;
}