## Goal

Thanks to the effort by some members of the AOSPA team, we introduce the repo that every device maintainer dreams of.
Since nowadays we're moving to commonized device trees, where most of the devices share the same requirements and blobs, we put together the most common QTI components in order to avoid duplicated configs all over the device trees, leaving them with a clean and more understandable device trees.

## SOCs supported per component

In order to a better understanding, here's a list of the components supported with the kernel families

| QTI Component       | Kernel Families supported       |
| ------------------- | :------------------------------ |
| Adreno (6xx)        | 4.9, 4.14, 4.19, 5.4            |
| Adreno Legacy (5xx) | 3.18, 4.4                       |
| Audio               | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Av                  | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| GPS                 | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Init                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Media               | 5.4                             |
| Media Legacy        | 3.18, 4.4, 4.9, 4.14, 4.19      |
| NQ-NFC              | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Overlay             | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Perf                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| USB                 | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Vibrator            | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| WFD                 | 4.9, 4.14, 4.19, 5.4            |
| WFD Legacy          | 3.18, 4.4                       |
| WLAN                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |

## Kernel Families

In case you're too lazy to go into common.mk, here's a list of the kernel families per soc.

| Kernel Family | SOCs                                       |
| ------------- | :----------------------------------------- |
| 5.4           | holi                                       |
| 4.19          | bengal, kona, lito                         |
| 4.14          | sm6150, trinket, atoll, msmnile,msmnile_au |
| 4.9           | msm8953, qcs605, sdm710, sdm845            |
| 4.4           | msm8998, sdm660                            |
| 3.18          | msm8937, msm8996                           |

## Advices

- Remember to always check the proprietary-files of each component you'll use in order to avoid duplicate stuff in your device trees.
- Check also the qti-*.mk to see the defined flags and components called
- In order to call the components you'll do it via "TARGET_COMMON_QTI_COMPONENTS" in your device.mk
- If you wish to add all of the components use "all" in the qti components only

## Examples

- Using only specific components
  > TARGET_COMMON_QTI_COMPONENTS := \
  > adreno-legacy \
  > wlan

- Using all the components you only need this
  > TARGET_COMMON_QTI_COMPONENTS := all

Copyright (C) 2021 Paranoid Android
