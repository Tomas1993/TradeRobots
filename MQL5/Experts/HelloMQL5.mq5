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

#include "..\Files\LWP_Symbol.mqh"
#include "..\Files\LWP_EAConfig.mqh"
#include "..\Files\GUI\ControlDialog.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+

input float iBrokerage_Rate;

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+

CControlsDialog   ExtDialog;

LWP_Symbol        acoes;
LWP_EAConfig      generalConfig;

CAccountInfo      AccountInfo;
CPositionInfo     PositionInfo;
CSymbolInfo       SymbolInfo;

long              leverage;

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
int OnInit(void)
{
   ///////////////////////////
   /// First, create a GUI ///
   ///////////////////////////
   if(!ExtDialog.Create(0,
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
   }

   acoes.populateAcoesDayTrade();

   // Set event generation frequency (1 second)
   EventSetMillisecondTimer(1000);
   
   // Check every symbol defined inside 'acoes'
   acoes.checkForSymbolsInMarketWatch();
      
   // Add BrokerageRate to LWP_EAConfig class
   generalConfig.setBrokerageRate(iBrokerage_Rate);
   
   // Get the leverage for the account
   leverage = AccountInfo.Leverage();
   
   // First step to the state Machine
   generalConfig.setTimeFramesStateMachine(PERIOD_M1);
   
   // Open Every Indicator for all charts and periods
   acoes.openBollingerBandsForDesiredPeriod();
                                         
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

   acoes.getInfoOfEverySymbol();

   ////////////////////////////////////////
   /// Just print out the current info. ///
   ////////////////////////////////////////

   Comment("Account Balance: ", myAccountBalance, "\n",  
           "Account Profit:  ", myAccountProfit , "\n",
           "Account Equity:  ", myAccountEquity , "\n");

   //////////////////////////////////////////////////////////////
   /// The following lines are the MQL5 way to define a order ///
   //////////////////////////////////////////////////////////////

   ZeroMemory(myRequest);
   
   myRequest.action        = TRADE_ACTION_DEAL;
   myRequest.type          = ORDER_TYPE_BUY;
   myRequest.symbol        = _Symbol;
   myRequest.volume        = 0.01;
   myRequest.type_filling  = ORDER_FILLING_FOK;
   myRequest.price         = SymbolInfoDouble(_Symbol, 
                                              SYMBOL_ASK);                                 
   myRequest.tp            = 0;
   myRequest.deviation     = 50;

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
   
   switch(generalConfig.getTimeFramesStateMachine())
   {
      case PERIOD_M1:         
         generalConfig.setTimeFramesStateMachine(PERIOD_M2);
         
         break;
      
      case PERIOD_M2:
         generalConfig.setTimeFramesStateMachine(PERIOD_M3);
         
         break;
         
      case PERIOD_M3:
         generalConfig.setTimeFramesStateMachine(PERIOD_M4);
         
         break;
      
      case PERIOD_M4:
         generalConfig.setTimeFramesStateMachine(PERIOD_M5);
         
         break;
         
      case PERIOD_M5:
         generalConfig.setTimeFramesStateMachine(PERIOD_M6);
         
         break;
         
      case PERIOD_M6:
         generalConfig.setTimeFramesStateMachine(PERIOD_M10);
         
         break;
         
      case PERIOD_M10:
         generalConfig.setTimeFramesStateMachine(PERIOD_M12);
         
         break;   
         
      case PERIOD_M12:
         generalConfig.setTimeFramesStateMachine(PERIOD_M15);
         
         break;  
         
      case PERIOD_M15:
         generalConfig.setTimeFramesStateMachine(PERIOD_M20);
         
         break;    
         
      case PERIOD_M20:
         generalConfig.setTimeFramesStateMachine(PERIOD_M30);
         
         break;   
         
      case PERIOD_M30:
         generalConfig.setTimeFramesStateMachine(PERIOD_H1);
         
         break;   
         
      case PERIOD_H1:
         generalConfig.setTimeFramesStateMachine(PERIOD_H2);
         
         break;
         
      case PERIOD_H2:
         generalConfig.setTimeFramesStateMachine(PERIOD_H3);
         
         break;
         
      case PERIOD_H3:
         generalConfig.setTimeFramesStateMachine(PERIOD_H4);
         
         break;
         
      case PERIOD_H4:
         generalConfig.setTimeFramesStateMachine(PERIOD_H6);
         
         break;
         
      case PERIOD_H6:
         generalConfig.setTimeFramesStateMachine(PERIOD_H8);
         
         break;
         
      case PERIOD_H8:
         generalConfig.setTimeFramesStateMachine(PERIOD_H12);
         
         break;
         
      case PERIOD_H12:
         generalConfig.setTimeFramesStateMachine(PERIOD_D1);
         
         break;
         
      case PERIOD_D1:
         generalConfig.setTimeFramesStateMachine(PERIOD_W1);
         
         break;   
         
      case PERIOD_W1:
         generalConfig.setTimeFramesStateMachine(PERIOD_MN1);
         
         break;  
         
      case PERIOD_MN1:
         generalConfig.setTimeFramesStateMachine(PERIOD_M1);
         
         break;                         
            
      default:
         break;
   }

   // Section A: Main loop of the FOR operator for strategy A
   /*for(int A = 0; A < 1; A++)
   {
      //--- A.1: Check whether the symbol is allowed to be traded
      if(IsTrade_A[A] == false)
      {
         // terminate the current FOR iteration
         continue; 
      }
   }*/

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