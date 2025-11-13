package com.skillbridgeai.domain;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class SkillTest {

    @Test
    void testConstructorAndGetters() {
        Skill skill = new Skill(1L, "Java", "Backend");
        
        assertEquals(1L, skill.getId());
        assertEquals("Java", skill.getNome());
        assertEquals("Backend", skill.getCategoria());
    }

    @Test
    void testConstructorWithNullValues() {
        Skill skill = new Skill(null, null, null);
        
        assertNull(skill.getId());
        assertNull(skill.getNome());
        assertNull(skill.getCategoria());
    }

    @Test
    void testConstructorWithEmptyStrings() {
        Skill skill = new Skill(0L, "", "");
        
        assertEquals(0L, skill.getId());
        assertEquals("", skill.getNome());
        assertEquals("", skill.getCategoria());
    }

    @Test
    void testToString() {
        Skill skill = new Skill(1L, "Java", "Backend");
        String result = skill.toString();
        
        assertTrue(result.contains("Skill"));
        assertTrue(result.contains("id=1"));
        assertTrue(result.contains("nome=Java"));
        assertTrue(result.contains("categoria=Backend"));
    }
}
