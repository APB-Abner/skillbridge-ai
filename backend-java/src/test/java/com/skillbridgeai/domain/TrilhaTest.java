package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TrilhaTest {

    @Test
    void testConstructorAndGetters() {
        Trilha trilha = new Trilha(1L, "Java Avançado", "Dominar conceitos avançados de Java");
        
        assertEquals(1L, trilha.getId());
        assertEquals("Java Avançado", trilha.getNome());
        assertEquals("Dominar conceitos avançados de Java", trilha.getObjetivo());
    }

    @Test
    void testConstructorWithNullValues() {
        Trilha trilha = new Trilha(null, null, null);
        
        assertNull(trilha.getId());
        assertNull(trilha.getNome());
        assertNull(trilha.getObjetivo());
    }

    @Test
    void testToString() {
        Trilha trilha = new Trilha(1L, "Java Avançado", "Dominar conceitos avançados de Java");
        String result = trilha.toString();
        
        assertTrue(result.contains("Trilha"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("nome=Java Avançado"));
        assertTrue(result.contains("objetivo=Dominar conceitos avançados de Java"));
    }
}
