package br.com.fiap.skillbridgeai.domain;

public class Trilha {
  private Long id;
  private String nome;
  private String objetivo;

  public Trilha(Long id, String nome, String objetivo) {
    this.id = id;
    this.nome = nome;
    this.objetivo = objetivo;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public String getObjetivo() { return objetivo; }

  @Override
  public String toString() {
    return "Trilha" + "{" + "id=" + id + ", " + "nome=" + nome + ", " + "objetivo=" + objetivo + "}";
  }
}
