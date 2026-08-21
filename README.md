# USBFast17

这是一个面向越狱 iOS 设备的充电遥测实验项目。

## 重要说明

本项目**不会**把 USB-A 充电器软件伪装成 USB-PD，也不会强制修改 USB-C/Lightning 的 PD 协商、电压或电流。

USB-PD 协商依赖充电器、线材、接口和设备侧硬件/协议控制器。越狱 tweak 不能凭空让不支持 PD 的硬件完成 PD 协商。

当前版本只读取并记录 IOPMPowerSource 的部分充电/电池数据，便于判断实际充电情况。

## 构建

本项目按 Theos tweak 项目结构组织，目标为 arm64/arm64e。
