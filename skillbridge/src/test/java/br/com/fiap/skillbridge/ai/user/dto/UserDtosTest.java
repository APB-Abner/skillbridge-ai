package br.com.fiap.skillbridge.ai.user.dto;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UserDtosTest {
    @Test void request_toString_getters(){
        var r = new UserRequest("Abner","a@a.com","12345678901");
        assertEquals("Abner", r.nome()); assertNotNull(r.toString());
    }
    @Test void response_equals_hash(){
        var a = new UserResponse(1L,"A","a@a.com","12345678901");
        var b = new UserResponse(1L,"A","a@a.com","12345678901");
        assertEquals(a,b); assertEquals(a.hashCode(), b.hashCode());
    }
    @Test void update_getters(){
        var u = new UserUpdateRequest("B","b@b.com","10987654321");
        assertEquals("B", u.nome());
    }
}
