package com.skillbridgeai.service;

import com.skillbridgeai.domain.Recomendacao;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class RecomendadorServiceTest {

    private RecomendadorService recomendadorService;

    @BeforeEach
    void setUp() {
        recomendadorService = new RecomendadorService();
    }

    @Test
    void testGerarRecomendacoesNormal() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        assertNotNull(result);
        assertEquals(3, result.size());
    }

    @Test
    void testGerarRecomendacoesUsuarioId() {
        Long usuarioId = 10L;
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(usuarioId);
        
        for (Recomendacao rec : result) {
            assertEquals(usuarioId, rec.getUsuarioId());
        }
    }

    @Test
    void testGerarRecomendacoesScoreFit() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        // First recommendation should have highest score
        assertTrue(result.get(0).getScoreFit() >= result.get(1).getScoreFit());
        assertTrue(result.get(1).getScoreFit() >= result.get(2).getScoreFit());
    }

    @Test
    void testGerarRecomendacoesScoreFitValues() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        assertEquals(0.8, result.get(0).getScoreFit(), 0.001);
        assertEquals(0.6, result.get(1).getScoreFit(), 0.001);
        assertEquals(0.4, result.get(2).getScoreFit(), 0.001);
    }

    @Test
    void testGerarRecomendacoesTrilhaIds() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        assertEquals(1L, result.get(0).getTrilhaId());
        assertEquals(2L, result.get(1).getTrilhaId());
        assertEquals(3L, result.get(2).getTrilhaId());
    }

    @Test
    void testGerarRecomendacoesComUsuarioIdNull() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(null);
        
        assertNotNull(result);
        assertEquals(3, result.size());
        assertNull(result.get(0).getUsuarioId());
    }

    @Test
    void testGerarRecomendacoesComUsuarioIdZero() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(0L);
        
        assertNotNull(result);
        assertEquals(3, result.size());
        assertEquals(0L, result.get(0).getUsuarioId());
    }

    @Test
    void testGerarRecomendacoesComUsuarioIdNegativo() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(-5L);
        
        assertNotNull(result);
        assertEquals(3, result.size());
        assertEquals(-5L, result.get(0).getUsuarioId());
    }

    @Test
    void testGerarRecomendacoesIds() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        assertEquals(1L, result.get(0).getId());
        assertEquals(2L, result.get(1).getId());
        assertEquals(3L, result.get(2).getId());
    }

    @Test
    void testGerarRecomendacoesScoreFitNaoNegativo() {
        List<Recomendacao> result = recomendadorService.gerarRecomendacoes(1L);
        
        for (Recomendacao rec : result) {
            assertTrue(rec.getScoreFit() >= 0.0, 
                "Score fit should be non-negative: " + rec.getScoreFit());
        }
    }

    @Test
    void testGerarRecomendacoesMultiplasVezes() {
        List<Recomendacao> result1 = recomendadorService.gerarRecomendacoes(1L);
        List<Recomendacao> result2 = recomendadorService.gerarRecomendacoes(1L);
        
        assertEquals(result1.size(), result2.size());
        for (int i = 0; i < result1.size(); i++) {
            assertEquals(result1.get(i).getTrilhaId(), result2.get(i).getTrilhaId());
            assertEquals(result1.get(i).getScoreFit(), result2.get(i).getScoreFit());
        }
    }
}
