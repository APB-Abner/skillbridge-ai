package com.skillbridgeai;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.jupiter.api.Assertions.*;

class AppTest {

    private final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    private final PrintStream originalOut = System.out;

    @BeforeEach
    void setUpStreams() {
        System.setOut(new PrintStream(outContent));
    }

    @AfterEach
    void restoreStreams() {
        System.setOut(originalOut);
    }

    @Test
    void testMainExecutesWithoutErrors() {
        assertDoesNotThrow(() -> App.main(new String[]{}));
    }

    @Test
    void testMainGeneratesRecommendations() {
        App.main(new String[]{});
        String output = outContent.toString();
        
        assertNotNull(output);
        assertFalse(output.isEmpty());
        assertTrue(output.contains("Trilha"), "Output should contain 'Trilha'");
        assertTrue(output.contains("fit="), "Output should contain 'fit='");
    }

    @Test
    void testMainGeneratesThreeRecommendations() {
        App.main(new String[]{});
        String output = outContent.toString();
        
        // Count how many times "Trilha" appears (should be 3)
        int count = 0;
        int index = 0;
        while ((index = output.indexOf("Trilha", index)) != -1) {
            count++;
            index++;
        }
        assertEquals(3, count, "Should generate 3 recommendations");
    }
}
