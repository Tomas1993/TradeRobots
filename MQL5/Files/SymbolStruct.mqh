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
   string            symbolName;
   
   long              symbolID;
   
   uchar             symbolWeight;
   
   double            minLot;
   double            maxLot;
   double            point;
   double            contractSize;
   
   uint              dealNumber;
   
   Bollinger_Bands   BollingerBands[];
   
   Moving_Average    MovingAverage[];
   
   void              setInfoFromChart(void);
   
   void              executeDeal();
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
   this.minLot       = _symbolInfo.LotsMin();
   this.maxLot       = _symbolInfo.LotsMax();
   
   // Point value
   this.point        = _symbolInfo.Point();
   
   // Contract size
   this.contractSize = _symbolInfo.ContractSize();
   
   // Set some additional parameters
   this.dealNumber   = 0;

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolStruct::executeDeal(void)
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
   
   

   return;
}