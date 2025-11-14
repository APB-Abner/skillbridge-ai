package br.com.fiap.skillbridge.ai.user.service;

import br.com.fiap.skillbridge.ai.user.dto.UserRequest;
import br.com.fiap.skillbridge.ai.user.model.User;
import br.com.fiap.skillbridge.ai.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock UserRepository repo;
    @InjectMocks UserService service;

    @Test
    void create_ok_mapeiaEntityPraResponse() {
        var saved = new User();
        saved.setId(1L);
        saved.setNome("Abner");
        saved.setEmail("abner@fiap.com");
        saved.setCpf("12345678901");

        when(repo.save(any(User.class))).thenReturn(saved);

        var resp = service.create(new UserRequest("Abner","abner@fiap.com","12345678901"));

        assertEquals(1L, resp.id());
        assertEquals("Abner", resp.nome());
        assertEquals("abner@fiap.com", resp.email());
        assertEquals("12345678901", resp.cpf());
        verify(repo).save(any(User.class));
    }

    @Test
    void list_ok_retornaTodosMapeados() {
        var u = new User();
        u.setId(7L);
        u.setNome("Ana");
        u.setEmail("ana@fiap.com");
        u.setCpf("98765432100");
        when(repo.findAll()).thenReturn(List.of(u));

        var out = service.list();

        assertEquals(1, out.size());
        assertEquals(7L, out.get(0).id());
        assertEquals("Ana", out.get(0).nome());
    }
}
