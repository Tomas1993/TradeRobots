/**
 *  @file    HelloMQL5.mq5
 *  @author: leonardo.pereira
 *  @version v1.0
 *  @date    13 de mar de 2018
 *  @brief  
 *           https://www.mql5.com/en/articles/770
             https://www.mql5.com/en/articles/4233?utm_campaign=articles.list&utm_medium=special&utm_source=mt5editor
             https://www.mql5.com/en/articles/4233
             http://www.algotrading.com.br/categoria-produto/premium/page/2/
 */
 
#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.linkedin.com/in/leonardowinterpereira/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+

#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\PositionInfo.mqh>

#include "..\Files\Inputs.mqh"
#include "..\Files\LWP_Symbol.mqh"
#include "..\Files\LWP_EAConfig.mqh"
#include "..\Files\GUI\ControlDialog.mqh"

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+

LWP_Symbol        acoesDayTrade(0,
                                0,
                                timeFrames_AcoesDayTrade);

CControlsDialog   ExtDialog;

LWP_EAConfig      generalConfig;

CAccountInfo      AccountInfo;
CSymbolInfo       SymbolInfo;

CTrade            Trade;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnStart(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void configAcoesDayTrade(void)
{  
   //
   acoesDayTrade = new LWP_Symbol(MODERADO, 
                                  ACOES_DAY_TRADE,
                                  timeFrames_AcoesDayTrade);

   //
   populaAtivosAcoesDayTrade(acoesDayTrade.symbolArray);
   
   // Run though the vector configurating everything needed
   acoesDayTrade.initialConfigs();
   
   ///////////////////////////////////////////////////////////////
   /// Config every single Indicator we will use for day trade ///
   ///////////////////////////////////////////////////////////////
   
   // Primeiro percorre o vetor de ativos
   for(int i = 0; i < ArraySize(acoesDayTrade.symbolArray); i++)
   {
      string name = acoesDayTrade.symbolArray[i].symbolName;
       
      // segundo, varre o vetor de periodos
      for(int j = 0; j < ArraySize(acoesDayTrade.timeFrames); j++)
      {
         ENUM_TIMEFRAMES timeframe = acoesDayTrade.timeFrames[j];
      
         acoesDayTrade.symbolArray[i].BollingerBands[j].BollingerBandsConfigs.setBollingerBandsIndicator(iBB_Period, 
                                                                                                         iBB_HorizontalShift,
                                                                                                         iBB_StandardDeviation);  
                                                                                                         
         acoesDayTrade.symbolArray[i].MovingAverage[j].MovingAverageConfigs.setMovingAverageIndicator(iMA_ShortPeriod, 
                                                                                                      iMA_MediumPeriod,
                                                                                                      iMA_LongPeriod,
                                                                                                      iMA_Shift,
                                                                                                      iMA_Method,
                                                                                                      PRICE_CLOSE);
      }
   }

   // Open Every Indicator for all charts and periods
   acoesDayTrade.openAllIndicators();
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void configAcoesSwingTrade(void)
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void configContratosFuturos(void)
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void configFII(void)
{
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void configOpcoes(void)
{
   return;
}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
{
   ///////////////////////////
   /// First, create a GUI ///
   ///////////////////////////
   /*if(!ExtDialog.Create(0,
                        "RoboTrader",
                        0,
                        20,
                        20,
                        360,
                        324))
   {
      return INIT_FAILED;
   }
   
   if(!ExtDialog.Run())
   {
      return INIT_FAILED;
   }*/

   // Set event generation frequency (1 second)
   EventSetMillisecondTimer(1000);
      
   // Add BrokerageRate to LWP_EAConfig class
   generalConfig.setBrokerageRate(iBrokerage_Rate);
   
   // Get the leverage for the account
   generalConfig.setLeverage(AccountInfo.Leverage());

   configAcoesDayTrade();
   configAcoesSwingTrade();
   configContratosFuturos();
   configFII();
   configOpcoes();
                                         
   return INIT_SUCCEEDED;
}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Stop event generation
   EventKillTimer();
   
   // Delete indicator handles

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   ///////////////////////////////
   /// Variable Initialization ///
   ///////////////////////////////
   
   MqlTradeRequest myRequest;
   MqlTradeResult  myResult;

   double myAccountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double myAccountProfit  = AccountInfoDouble(ACCOUNT_PROFIT);
   double myAccountEquity  = AccountInfoDouble(ACCOUNT_EQUITY);

   ////////////////////////////////////////
   /// Just print out the current info. ///
   ////////////////////////////////////////

   Comment("Account Balance: ", myAccountBalance, "\n",  
           "Account Profit:  ", myAccountProfit , "\n",
           "Account Equity:  ", myAccountEquity , "\n");
   
   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
{
   // Check if the terminal is connected to the trade server
   if(TerminalInfoInteger(TERMINAL_CONNECTED) == false)
   { 
      return;
   }
   
   acoesDayTrade.getFeedBackFromIndicators(ACOMPANHAMENTO_TENDENCIA);

   return;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTrade(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTradeTransaction(const MqlTradeTransaction&    trans,        // trade transaction structure 
//                        const MqlTradeRequest&        request,      // request structure 
//                        const MqlTradeResult&         result)       // result structure
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//double OnTester(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterInit(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterPass(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnTesterDeinit(void)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnBookEvent(const string& symbol)
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void OnChartEvent(const int id,         // Event ID 
//                  const long& lparam,   // Parameter of type long event 
//                  const double& dparam, // Parameter of type double event 
//                  const string& sparam) // Parameter of type string events 
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int OnCalculate (const int rates_total,      // size of the price[] array 
//                 const int prev_calculated,  // bars handled on a previous call 
//                 const int begin,            // where the significant data start from 
//                 const double& price[])      // array to calculate 
//{
//   return;
//}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//int OnCalculate (const int rates_total,      // size of input time series 
//                 const int prev_calculated,  // bars handled in previous call 
//                 const datetime& time[],     // Time 
//                 const double& open[],       // Open 
//                 const double& high[],       // High 
//                 const double& low[],        // Low 
//                 const double& close[],      // Close 
//                 const long& tick_volume[],  // Tick Volume 
//                 const long& volume[],       // Real Volume 
//                 const int& spread[])        // Spread 
//{
//   return;
//}