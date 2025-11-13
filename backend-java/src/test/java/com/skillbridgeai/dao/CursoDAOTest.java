package com.skillbridgeai.dao;

import com.skillbridgeai.domain.Curso;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class CursoDAOTest {

    private CursoDAO cursoDAO;

    @BeforeEach
    void setUp() {
        cursoDAO = new CursoDAO();
    }

    @Test
    void testSave() {
        Curso curso = new Curso(1L, "Spring Boot Fundamentals", 40, 3);
        Curso saved = cursoDAO.save(curso);
        
        assertNotNull(saved);
        assertEquals(curso.getId(), saved.getId());
        assertEquals(curso.getNome(), saved.getNome());
        assertEquals(curso.getDuracaoHoras(), saved.getDuracaoHoras());
        assertEquals(curso.getDificuldade(), saved.getDificuldade());
    }

    @Test
    void testSaveNullCurso() {
        Curso saved = cursoDAO.save(null);
        assertNull(saved);
    }

    @Test
    void testFindById() {
        Optional<Curso> result = cursoDAO.findById(1L);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindByIdWithNull() {
        Optional<Curso> result = cursoDAO.findById(null);
        
        assertNotNull(result);
        assertFalse(result.isPresent());
    }

    @Test
    void testFindAll() {
        List<Curso> result = cursoDAO.findAll();
        
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
