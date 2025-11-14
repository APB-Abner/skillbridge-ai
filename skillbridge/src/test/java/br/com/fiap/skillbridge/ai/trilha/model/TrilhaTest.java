package br.com.fiap.skillbridge.ai.trilha.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class TrilhaTest {

    @Test
    void builder_criaComTodosOsCampos() {
        var t = Trilha.builder()
                .id(1L)
                .titulo("Java")
                .descricao("Descrição")
                .ativa(true)
                .build();

        assertEquals(1L, t.getId());
        assertEquals("Java", t.getTitulo());
        assertEquals("Descrição", t.getDescricao());
        assertTrue(t.isAtiva());
    }

    @Test
    void builder_default_ativaTrue() {
        var t = Trilha.builder()
                .titulo("Python")
                .build();

        assertTrue(t.isAtiva());
    }

    @Test
    void setters_funcionam() {
        var t = new Trilha();
        t.setId(5L);
        t.setTitulo("Go");
        t.setDescricao("Lang");
        t.setAtiva(false);

        assertEquals(5L, t.getId());
        assertEquals("Go", t.getTitulo());
        assertEquals("Lang", t.getDescricao());
        assertFalse(t.isAtiva());
    }

    @Test
    void noArgsConstructor_criaInstanciaVazia() {
        var t = new Trilha();
        assertNull(t.getId());
        assertNull(t.getTitulo());
        assertNull(t.getDescricao());
        assertFalse(t.isAtiva()); // primitivo boolean = false
    }

    @Test
    void allArgsConstructor_defineValores() {
        var t = new Trilha(10L, "Kotlin", "Desc", true);

        assertEquals(10L, t.getId());
        assertEquals("Kotlin", t.getTitulo());
        assertEquals("Desc", t.getDescricao());
        assertTrue(t.isAtiva());
    }
}

