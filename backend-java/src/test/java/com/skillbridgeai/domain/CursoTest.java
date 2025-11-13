package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CursoTest {

    @Test
    void testConstructorAndGetters() {
        Curso curso = new Curso(1L, "Spring Boot Fundamentals", 40, 3);
        
        assertEquals(1L, curso.getId());
        assertEquals("Spring Boot Fundamentals", curso.getNome());
        assertEquals(40, curso.getDuracaoHoras());
        assertEquals(3, curso.getDificuldade());
    }

    @Test
    void testConstructorWithMinimumValues() {
        Curso curso = new Curso(0L, "", 0, 0);
        
        assertEquals(0L, curso.getId());
        assertEquals("", curso.getNome());
        assertEquals(0, curso.getDuracaoHoras());
        assertEquals(0, curso.getDificuldade());
    }

    @Test
    void testConstructorWithMaximumValues() {
        Curso curso = new Curso(Long.MAX_VALUE, "Test", Integer.MAX_VALUE, Integer.MAX_VALUE);
        
        assertEquals(Long.MAX_VALUE, curso.getId());
        assertEquals(Integer.MAX_VALUE, curso.getDuracaoHoras());
        assertEquals(Integer.MAX_VALUE, curso.getDificuldade());
    }

    @Test
    void testToString() {
        Curso curso = new Curso(1L, "Spring Boot Fundamentals", 40, 3);
        String result = curso.toString();
        
        assertTrue(result.contains("Curso"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("nome=Spring Boot Fundamentals"));
        assertTrue(result.contains("duracaoHoras=40"));
        assertTrue(result.contains("dificuldade=3"));
    }
}
