
package com.skillbridgeai.service;

public class ProgressoService {
  public double calcularProgresso(double modulosConcluidos, double totalModulos) {
    if (totalModulos <= 0) return 0.0;
    return (modulosConcluidos / totalModulos) * 100.0;
  }

  public int estimarConclusaoDias(double horasSemana, double cargaHorariaRestante) {
    if (horasSemana <= 0) return Integer.MAX_VALUE;
    double semanas = cargaHorariaRestante / horasSemana;
    return (int)Math.ceil(semanas * 7);
  }
}
