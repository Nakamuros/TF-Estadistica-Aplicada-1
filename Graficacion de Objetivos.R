install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("lubridate")

library(ggplot2)
library(readr)
library(dplyr)
library(lubridate)

setwd("C:/Users/agabr/OneDrive/Desktop ASUS/Desktop/Aplicaciones/UPC/2025-02/Estadistica Aplicada I")
datos <- read_csv("Reporte - exportaciones62.csv")

View(datos)
head(datos)
str(datos)

#===============FILTRACION PARA GRAFICO1==============

junio <- datos%>%
  filter(Mes == 6)

junio <- junio %>%
  select(Región, País, `US$ FOB`) %>%
  group_by(Región, País) %>%
  summarise(total_fob = sum(`US$ FOB`, na.rm = TRUE)) %>%
  ungroup()

junio <- junio %>%
  group_by(Región) %>%
  mutate(porcentaje = total_fob / sum(total_fob)) %>%
  ungroup()
#===============FILTRACION PARA GRAFICO2==============

# Convertir la fecha numérica tipo 20250101 a formato fecha
datos <- datos %>%
  mutate(
    Fecha = as.Date(as.character(`Fecha de Embarque`), format = "%Y%m%d"),
    Peso_ton = as.numeric(`Peso Neto (Kg.)`) / 1000
  )

# Filtrar por Canadá, EE.UU. y primeros 20 días de marzo 2025
datos_filtrado <- datos %>%
  filter(
    `País` %in% c("CANADA", "ESTADOS UNIDOS"),
    format(Fecha, "%Y-%m") == "2025-03",
    as.numeric(format(Fecha, "%d")) <= 20
  )

# Mostrar cuántos datos hay (para verificar)
print(paste("Filas encontradas:", nrow(datos_filtrado)))
#===============FILTRACION PARA GRAFICO4==============
datos <- datos %>%
  rename(Costo_CIF = `FOB US$ / Unidades`)

datos_filtrados <- datos %>%
  filter(País %in% c("ESTADOS UNIDOS", "CANADA", "MEXICO"))

resumen <- datos_filtrados %>%
  group_by(País) %>%
  summarise(
    media = mean(Costo_CIF, na.rm = TRUE),
    mediana = median(Costo_CIF, na.rm = TRUE),
    desviacion = sd(Costo_CIF, na.rm = TRUE),
    minimo = min(Costo_CIF, na.rm = TRUE),
    maximo = max(Costo_CIF, na.rm = TRUE),
    q1 = quantile(Costo_CIF, 0.25, na.rm = TRUE),
    q3 = quantile(Costo_CIF, 0.75, na.rm = TRUE)
  )

print(resumen)
#==============GRAFICACION DE OBJETIVOS===============

#OBJETIVO 1
ggplot(junio, aes(x = Región, y = porcentaje, fill = País)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(round(porcentaje * 100, 1), "%")),
            position = position_stack(vjust = 0.5),  # centra el texto dentro de cada segmento
            size = 3.5, color = "black") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Distribución de exportación de mango desde Perú a América del Norte según región",
    #subtitle = "Porcentaje del valor FOB por región y país de destino",
    x = "Región exportadora",
    y = "Porcentaje de exportacion",
    fill = "País"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
#OBJETIVO 2
if (nrow(datos_filtrado) > 0) {
  ggplot(datos_filtrado, aes(x = Peso_ton, fill = `País`)) +
    geom_histogram(bins = 10, alpha = 0.6, position = "identity", color = "white") +
    labs(
      title = "Distribución del peso neto de mango segun la frecuencia de envio ",
      x = "Peso neto por envío (toneladas)",
      y = "Frecuencia de envíos",
      fill = "País destino"
    ) +
    theme_minimal(base_size = 13)
} else {
  cat("⚠No hay datos disponibles para el rango o países especificados.\n")
}

#OBJETIVO 4
ggplot(datos_filtrados, aes(x = País, y = Costo_CIF, fill = País)) +
  geom_boxplot(outlier.color = "red", outlier.size = 2) +
  labs(
    title = "Distribución del valor FOB (US$/Unidad) segun país de destino - 2025",
    x = "País de destino",
    y = "Valor FOB (US$/Unidad)"
  ) +
  theme_minimal()


#EJEMPLO
# Transformar variable de fecha
datos <- datos %>%
  mutate(Fecha = as.Date(as.character(`Fecha de Embarque`), format = "%Y%m%d"))

# Filtrar datos: marzo 2025, primeros 20 días, países Canadá y EE.UU.
datos_filtrado <- datos %>%
  filter(
    `País` %in% c("CANADA", "ESTADOS UNIDOS"),
    format(Fecha, "%Y-%m") == "2025-03",
    as.numeric(format(Fecha, "%d")) <= 20
  )

# Crear variable cuantitativa: Peso Neto (Kg.)
peso <- as.numeric(datos_filtrado$`Peso Neto (Kg.)`)

# Eliminar valores NA
peso <- peso[!is.na(peso)]

# --- Construcción de tabla de frecuencia agrupada ---

# Número de clases (puedes ajustar)
k <- 6

# Límites
Li <- min(peso)
Ls <- max(peso)
amplitud <- (Ls - Li) / k

# Crear intervalos
intervalos <- cut(peso,
                  breaks = seq(Li, Ls, by = amplitud),
                  include.lowest = TRUE,
                  right = FALSE)

# Calcular frecuencias
tabla <- as.data.frame(table(intervalos))
colnames(tabla) <- c("Clase", "fi")

# Agregar columnas de límites e intervalos numéricos
tabla <- tabla %>%
  mutate(
    Li = seq(Li, Ls - amplitud, by = amplitud),
    Ls = Li + amplitud,
    Xi = round((Li + Ls) / 2, 2),
    Fi = cumsum(fi),
    pi = round((fi / sum(fi)) * 100, 1),
    Pi = round(cumsum(pi), 1)
  ) %>%
  select(Li, Ls, Xi, fi, pi, Fi, Pi)

# Mostrar tabla final
print(tabla)

# Totales
cat("\nTotal:", sum(tabla$fi), "observaciones\n")


# ==============================================================================
# OBJETIVO 3: TABLA DE RESUMEN VISUAL (ESTILO EXCEL / IMAGEN)
# ==============================================================================

# 1. Instalar librerías gráficas (si no las tienes)
install.packages("e1071")     # Para asimetría/curtosis
install.packages("gridExtra") # Para dibujar tablas
install.packages("dplyr")
install.packages("tidyr") # Para transponer

library(e1071)
library(gridExtra)
library(dplyr)
library(tidyr)
library(grid) # Necesario para guardar la imagen

# Función para Moda
get_mode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# 2. Preparar Datos
datos_obj3 <- datos %>%
  mutate(FOB_Clean = as.numeric(gsub(",", "", `US$ FOB`))) %>%
  filter(Año == 2025, Mes <= 6)

# 3. Calcular TODOS los indicadores
tabla_calculada <- datos_obj3 %>%
  group_by(`Vía de transporte`) %>%
  summarise(
    Media = mean(FOB_Clean, na.rm = TRUE),
    Error_Tipico = sd(FOB_Clean, na.rm = TRUE) / sqrt(n()),
    Mediana = median(FOB_Clean, na.rm = TRUE),
    Moda = get_mode(FOB_Clean),
    Desv_Estandar = sd(FOB_Clean, na.rm = TRUE),
    Varianza = var(FOB_Clean, na.rm = TRUE),
    Curtosis = kurtosis(FOB_Clean, na.rm = TRUE),
    Asimetria = skewness(FOB_Clean, na.rm = TRUE),
    Rango = max(FOB_Clean, na.rm = TRUE) - min(FOB_Clean, na.rm = TRUE),
    Minimo = min(FOB_Clean, na.rm = TRUE),
    Maximo = max(FOB_Clean, na.rm = TRUE),
    Suma = sum(FOB_Clean, na.rm = TRUE),
    Cuenta = n()
  ) %>%
  mutate(across(where(is.numeric), ~ round(., 2))) # Redondear a 2 decimales

# 4. TRANSPONER LA TABLA (Girar filas por columnas)
# Esto es clave para que se vea igual a tu captura de Excel
tabla_visual <- t(tabla_calculada[,-1]) # Quitamos la 1ra columna (nombres) para transponer solo números
colnames(tabla_visual) <- tabla_calculada$`Vía de transporte` # Ponemos los nombres de las vías arriba

# 5. DIBUJAR Y GUARDAR COMO IMAGEN (PLOT)
# Guardamos como PNG de alta calidad
png("Tabla_Resumen_Final.png", width = 850, height = 400) # Tamaño ajustado

# Usamos un tema visual limpio (estilo Excel)
tt <- ttheme_default(
  core = list(bg_params = list(fill = c("white", "#f0f0f0")), # Filas alternas gris/blanco
              fg_params = list(fontsize = 10)),
  colhead = list(bg_params = list(fill = "#4472C4"), # Encabezado Azul
                 fg_params = list(col = "white", fontface = "bold"))
)

grid.table(tabla_visual, theme = tt)

dev.off()

cat("✅ ¡Listo! Busca el archivo 'Tabla_Resumen_Final.png' en tu carpeta de trabajo.")