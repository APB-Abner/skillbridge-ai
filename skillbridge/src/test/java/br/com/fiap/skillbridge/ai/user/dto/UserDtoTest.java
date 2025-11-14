package br.com.fiap.skillbridge.ai.user.dto;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserDtoTest {

    @Test
    void userRequest_criaComCampos() {
        var req = new UserRequest("Abner", "abner@fiap.com", "12345678901");
        assertEquals("Abner", req.nome());
        assertEquals("abner@fiap.com", req.email());
        assertEquals("12345678901", req.cpf());
    }

    @Test
    void userUpdateRequest_criaComCampos() {
        var req = new UserUpdateRequest("Ana", "ana@fiap.com", "98765432100");
        assertEquals("Ana", req.nome());
        assertEquals("ana@fiap.com", req.email());
        assertEquals("98765432100", req.cpf());
    }

    @Test
    void userResponse_criaComTodosCampos() {
        var resp = new UserResponse(1L, "Bruno", "bruno@fiap.com", "11122233344");
        assertEquals(1L, resp.id());
        assertEquals("Bruno", resp.nome());
        assertEquals("bruno@fiap.com", resp.email());
        assertEquals("11122233344", resp.cpf());
    }
}

