//+------------------------------------------------------------------+
//|                                                     EAConfig.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LWP_EAConfig
{
   private:
      float brokerage_rate;
      
      ENUM_TIMEFRAMES timeFramesStateMachine;
   
   protected:
   
   public:
      LWP_EAConfig();
      
      ~LWP_EAConfig();
      
      void              setBrokerageRate(float inputValue)                    { this.brokerage_rate = inputValue; }
      float             getBrokerageRate(void)                                { return this.brokerage_rate; }
      
      void              setTimeFramesStateMachine(ENUM_TIMEFRAMES inputValue) { this.timeFramesStateMachine = inputValue; }
      ENUM_TIMEFRAMES   getTimeFramesStateMachine(void)                       { return this.timeFramesStateMachine; }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_EAConfig::LWP_EAConfig()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LWP_EAConfig::~LWP_EAConfig()
{
}
//+------------------------------------------------------------------+
