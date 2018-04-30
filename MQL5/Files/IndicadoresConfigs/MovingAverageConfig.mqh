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

class Moving_Average_Configuration
{
   private:
      uint                 shortPeriod;
      uint                 mediumPeriod;
      uint                 longPeriod;
      
      int                  shift;
      
      ENUM_MA_METHOD       method;
      
      ENUM_APPLIED_PRICE   applied_price;
   
   protected:
   
   public:   
      void                 setMovingAverageIndicator(uint               _shortPeriod,
                                                     uint               _mediumPeriod,
                                                     uint               _longPeriod,
                                                     int                _shift,
                                                     ENUM_MA_METHOD     _method,
                                                     ENUM_APPLIED_PRICE _applied_price);
};
