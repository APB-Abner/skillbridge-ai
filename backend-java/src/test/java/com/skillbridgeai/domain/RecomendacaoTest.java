package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class RecomendacaoTest {

    @Test
    void testConstructorAndGetters() {
        Recomendacao recomendacao = new Recomendacao(1L, 10L, 20L, 0.85);
        
        assertEquals(1L, recomendacao.getId());
        assertEquals(10L, recomendacao.getUsuarioId());
        assertEquals(20L, recomendacao.getTrilhaId());
        assertEquals(0.85, recomendacao.getScoreFit());
    }

    @Test
    void testConstructorWithMinScoreFit() {
        Recomendacao recomendacao = new Recomendacao(2L, 11L, 21L, 0.0);
        
        assertEquals(0.0, recomendacao.getScoreFit());
    }

    @Test
    void testConstructorWithMaxScoreFit() {
        Recomendacao recomendacao = new Recomendacao(3L, 12L, 22L, 1.0);
        
        assertEquals(1.0, recomendacao.getScoreFit());
    }

    @Test
    void testConstructorWithNegativeScoreFit() {
        Recomendacao recomendacao = new Recomendacao(4L, 13L, 23L, -0.5);
        
        assertEquals(-0.5, recomendacao.getScoreFit());
    }

    @Test
    void testToString() {
        Recomendacao recomendacao = new Recomendacao(1L, 10L, 20L, 0.85);
        String result = recomendacao.toString();
        
        assertTrue(result.contains("Recomendacao"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("usuarioId=10"));
        assertTrue(result.contains("trilhaId=20"));
        assertTrue(result.contains("scoreFit=0.85"));
    }
}
