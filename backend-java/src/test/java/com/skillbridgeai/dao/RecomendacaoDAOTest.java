package com.skillbridgeai.dao;

import com.skillbridgeai.domain.Recomendacao;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class RecomendacaoDAOTest {

    private RecomendacaoDAO recomendacaoDAO;

    @BeforeEach
    void setUp() {
        recomendacaoDAO = new RecomendacaoDAO();
    }

    @Test
    void testSave() {
        Recomendacao recomendacao = new Recomendacao(1L, 10L, 20L, 0.85);
        Recomendacao saved = recomendacaoDAO.save(recomendacao);
        
        assertNotNull(saved);
        assertEquals(recomendacao.getId(), saved.getId());
        assertEquals(recomendacao.getUsuarioId(), saved.getUsuarioId());
        assertEquals(recomendacao.getTrilhaId(), saved.getTrilhaId());
        assertEquals(recomendacao.getScoreFit(), saved.getScoreFit());
    }

    @Test
    void testSaveNullRecomendacao() {
        Recomendacao saved = recomendacaoDAO.save(null);
        assertNull(saved);
    }

    @Test
    void testFindById() {
        Optional<Recomendacao> result = recomendacaoDAO.findById(1L);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindByIdWithNull() {
        Optional<Recomendacao> result = recomendacaoDAO.findById(null);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindAll() {
        List<Recomendacao> result = recomendacaoDAO.findAll();
        
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
