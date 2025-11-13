package br.com.fiap.skillbridgeai.domain;

public class Curso {
  private Long id;
  private String nome;
  private int duracaoHoras;
  private int dificuldade;

  public Curso(Long id, String nome, int duracaoHoras, int dificuldade) {
    this.id = id;
    this.nome = nome;
    this.duracaoHoras = duracaoHoras;
    this.dificuldade = dificuldade;
  }

  public Long getId() { return id; }
  public String getNome() { return nome; }
  public int getDuracaoHoras() { return duracaoHoras; }
  public int getDificuldade() { return dificuldade; }

  @Override
  public String toString() {
    return "Curso" + "{" + "id=" + id + ", " + "nome=" + nome + ", " + "duracaoHoras=" + duracaoHoras + ", " + "dificuldade=" + dificuldade + "}";
  }
}
