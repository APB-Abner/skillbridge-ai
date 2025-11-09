package com.skillbridgeai.domain;

public class Matricula {
  private Long id;
  private Long usuarioId;
  private Long trilhaId;
  private String status;
  private double progressoPct;
  private double horasEst;

  public Matricula(Long id, Long usuarioId, Long trilhaId, String status, double progressoPct, double horasEst) {
    this.id = id;
    this.usuarioId = usuarioId;
    this.trilhaId = trilhaId;
    this.status = status;
    this.progressoPct = progressoPct;
    this.horasEst = horasEst;
  }

  public Long getId() { return id; }
  public Long getUsuarioId() { return usuarioId; }
  public Long getTrilhaId() { return trilhaId; }
  public String getStatus() { return status; }
  public double getProgressoPct() { return progressoPct; }
  public double getHorasEst() { return horasEst; }

  @Override
  public String toString() {
    return "Matricula" + "{" + "id=" + id + ", " + "usuarioId=" + usuarioId + ", " + "trilhaId=" + trilhaId + ", " + "status=" + status + ", " + "progressoPct=" + progressoPct + ", " + "horasEst=" + horasEst + "}";
  }
}
