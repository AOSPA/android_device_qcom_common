## Goal

Considering how CAF commonises configs and proprietary blobs for different board platforms and putting forward a helping hand towards keeping device trees as clean and good as it can be, we put together this repository of common QTI components.

## QTI Components and their supported Kernel Families

| QTI Component       | Kernel Families Supported       |
| ------------------- | :------------------------------ |
| Adreno(6xx)         | 4.9, 4.14, 4.19, 5.4            |
| Adreno(legacy, 5xx) | 3.18, 4.4, 4.9, 4.19            |
| Audio               | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| AV                  | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| GPS                 | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Init                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Media               | 5.4                             |
| Media(legacy)       | 3.18, 4.4, 4.9, 4.14, 4.19      |
| NQ-NFC              | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Overlay             | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Perf                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| USB                 | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| Vibrator            | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |
| WFD                 | 4.9, 4.14, 4.19, 5.4            |
| WLAN                | 3.18, 4.4, 4.9, 4.14, 4.19, 5.4 |

## Board Platforms and their supported kernel families

| Kernel Family | Board Platforms                            |
| ------------- | :----------------------------------------- |
| 5.4           | holi, lahaina                              |
| 4.19          | bengal, kona, lito, sdm660, msm89xx        |
| 4.14          | sm6150, trinket, atoll, msmnile, sdm660    |
| 4.9           | msm8953, qcs605, sdm710, sdm845            |
| 4.4           | msm8998, sdm660                            |
| 3.18          | msm8937, msm8996                           |

## Important Notes

- Make sure to compare your device tree's makefile and proprietary blob listing with that of the respective QTI components to avoid overriding or conflicts.
- To inherit the components, define the name of the components along with `TARGET_COMMON_QTI_COMPONENTS` flag in your device makefile.
- If you wish to inherit all of the components(doesn't include legacy components), use `all` in place of the name of QTI component as mentioned in previous point.

## Reference

- Using only specific components

```bash
   TARGET_COMMON_QTI_COMPONENTS := \
   adreno-legacy \
   wlan
```

- Using all the components you only need this

```bash
   TARGET_COMMON_QTI_COMPONENTS := all
```

## Copyrights

```bash
#
# Copyright (C) 2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#
```
