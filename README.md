# TF-Estadistica-Aplicada-1
# 🥭 Análisis Estadístico: Exportación de Mango Peruano a Norteamérica (2025)

![Status](https://img.shields.io/badge/Status-Finalizado-success)
![Language](https://img.shields.io/badge/R-4.2+-blue)
![Data](https://img.shields.io/badge/Data-ADEX%20Data%20Trade-orange)
![Course](https://img.shields.io/badge/Curso-Estadística%20Aplicada%201-red)

> **Proyecto Final - UPC 2025**
> Análisis descriptivo e inferencial sobre el impacto del proteccionismo comercial en la campaña de exportación de mango.

## 📄 Descripción del Proyecto

Este proyecto analiza el comportamiento de las exportaciones de mango (partida `0804502000`) desde Perú hacia sus principales socios comerciales en América del Norte (**Estados Unidos, Canadá y México**) durante el primer semestre del 2025.

En un contexto global marcado por la reactivación de **guerras comerciales y medidas proteccionistas**, este estudio utiliza herramientas estadísticas para identificar:
* Patrones de dependencia comercial por regiones (Ancash, Piura, Ica).
* Estandarización logística y barreras de entrada por volumen de carga.
* Variabilidad de precios FOB y ventanas de oportunidad de mercado.

## 📊 Dataset y Muestra

* **Fuente:** ADEX Data Trade.
* **Periodo:** Enero - Junio 2025.
* **Muestra:** $n = 4,263$ registros de exportación (Censo del primer semestre).
* **Variables Clave:** Valor FOB (US$), Peso Neto (Kg), Vía de Transporte, Región de Origen, País de Destino.

## 🛠️ Tecnologías y Herramientas

* **Lenguaje:** R (Librerías: `dplyr`, `ggplot2`, `readr`, `e1071`).
* **Análisis Exploratorio:** Microsoft Excel (Tablas dinámicas, Histogramas).
* **Control de Versiones:** Git & GitHub.

## 📈 Resultados Destacados

El análisis estadístico arrojó los siguientes hallazgos clave:

1.  **Dependencia Crítica:** El **82.2%** del valor exportado depende exclusivamente del mercado de **Estados Unidos**, representando un riesgo alto ante posibles barreras arancelarias.
2.  **Rigidez Logística:** El **96%** de la carga se moviliza por vía marítima. Se detectó una fuerte estandarización en contenedores de **20 a 25 toneladas**, lo que dificulta el acceso a pequeños productores sin capacidad de consolidación.
3.  **Precios vs. Estabilidad:** Mientras **México** ofrece un mercado estable para regiones como Ancash (100% de sus envíos), **EE.UU.** presenta los precios unitarios más altos pero con mayor volatilidad (*outliers*), premiando la calidad sobre el volumen.

## 📂 Estructura del Repositorio

```text
├── data/
│   └── Reporte_exportaciones_2025.csv   # Dataset crudo (anonimizado)
├── scripts/
│   ├── 01_limpieza_datos.R              # Script de pre-procesamiento
│   ├── 02_analisis_descriptivo.R        # Generación de tablas y medidas
│   └── 03_visualizaciones.R             # Gráficos (Barplots, Boxplots)
├── outputs/
│   ├── histograma_peso_neto.png         # Gráficos generados
│   └── tabla_resumen_fob.png            # Tablas de resumen
└── README.md                            # Documentación del proyecto
