//+------------------------------------------------------------------+
//|                                         BollingerBandsConfig.mqh |
//|                                  Copyright 2018, LeonardoPereira |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, LeonardoPereira"
#property link      "https://www.mql5.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

class Bollinger_Bands_Configuration
{
   private:
      uint              movingAverage_Period;
      
      int               horizontalShift;
      
      double            standardDeviation;
   
   protected:
   
   public:   
      uint     getMovingAveragePeriod(void)  { return this.movingAverage_Period; }
      
      int      getHorizontalShift(void)      { return this.horizontalShift; }
      
      double   getStandardDeviation(void)    { return this.standardDeviation; }
   
      void     setBollingerBandsIndicator(uint     _movingAverage_Period, 
                                          int      _horizontalShift, 
                                          double   _standardDeviation);
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bollinger_Bands_Configuration::setBollingerBandsIndicator(uint            _movingAverage_Period, 
                                                               int             _horizontalShift, 
                                                               double          _standardDeviation)
{
   this.movingAverage_Period  = _movingAverage_Period;
   this.horizontalShift       = _horizontalShift;
   
   if(_standardDeviation > 0.0)
   {
      this.standardDeviation  = _standardDeviation;
   }
   
   else
   {
      Comment("The standard deviation of Bollinger Bands must be more than 0.0");
      
      ExpertRemove();
   }
   
   return;
}
