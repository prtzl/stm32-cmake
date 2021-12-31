// STM32 library will trip on these warnings
#pragma GCC diagnostic ignored "-Wold-style-cast"
#pragma GCC diagnostic ignored "-Wshadow"
#pragma GCC diagnostic ignored "-Wuseless-cast"

#include <Project/projectMain.h>
#include "main.h"

struct Led
{
	explicit Led(GPIO_TypeDef* gpio, uint16_t pin)
		: gpio(gpio), pin(pin)
	{}
	void on()
	{
		HAL_GPIO_WritePin(gpio, pin, GPIO_PIN_SET);
	}
	void off()
	{
		HAL_GPIO_WritePin(gpio, pin, GPIO_PIN_RESET);
	}
	void toggle()
	{
		HAL_GPIO_TogglePin(gpio, pin);
	}
	auto state() -> bool
	{
		return HAL_GPIO_ReadPin(gpio, pin);
	}
private:
	GPIO_TypeDef* gpio;
	uint16_t pin;
};

void projectMain()
{
    Led led(GPIOD, GPIO_PIN_15);

	while (true)
	{
		led.toggle();
		HAL_Delay(500);
	}
}
