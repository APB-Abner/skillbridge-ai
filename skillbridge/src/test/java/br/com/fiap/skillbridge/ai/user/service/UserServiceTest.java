package br.com.fiap.skillbridge.ai.user.service;

import br.com.fiap.skillbridge.ai.shared.exception.NotFoundException;
import br.com.fiap.skillbridge.ai.user.dto.*;
import br.com.fiap.skillbridge.ai.user.model.User;
import br.com.fiap.skillbridge.ai.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock UserRepository repo;
    @InjectMocks UserService service;

    @Test
    void create_ok(){
        var req = new UserRequest("Abner","abner@fiap.com","12345678901");
        when(repo.existsByEmail("abner@fiap.com")).thenReturn(false);
        when(repo.existsByCpf("12345678901")).thenReturn(false);
        when(repo.save(any())).thenAnswer(a -> {
            User u = a.getArgument(0);
            u.setId(1L); return u;
        });
        var res = service.create(req);
        assertEquals(1L, res.id());
        assertEquals("Abner", res.nome());
    }

    @Test
    void create_emailDuplicado_badRequest(){
        var req = new UserRequest("A","a@a.com","12345678901");
        when(repo.existsByEmail("a@a.com")).thenReturn(true);
        var ex = assertThrows(IllegalArgumentException.class, () -> service.create(req));
        assertTrue(ex.getMessage().toLowerCase().contains("e-mail"));
    }

    @Test
    void update_notFound(){
        when(repo.findById(99L)).thenReturn(Optional.empty());
        var req = new UserUpdateRequest("X","x@x.com","11111111111");
        assertThrows(NotFoundException.class, () -> service.update(99L, req));
    }

    @Test
    void delete_ok(){
        when(repo.existsById(1L)).thenReturn(true);
        service.delete(1L);
        verify(repo).deleteById(1L);
    }

    @Test
    void update_ok(){
        var existing = User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build();
        when(repo.findById(1L)).thenReturn(Optional.of(existing));
        when(repo.existsByEmail("b@b.com")).thenReturn(false);
        when(repo.existsByCpf("10987654321")).thenReturn(false);
        when(repo.save(any())).thenAnswer(a -> a.getArgument(0));

        var req = new UserUpdateRequest("B","b@b.com","10987654321");
        var res = service.update(1L, req);

        assertEquals("B", res.nome());
        assertEquals("b@b.com", res.email());
    }

    @Test
    void create_cpfDuplicado_badRequest(){
        var req = new UserRequest("A","a@a.com","12345678901");
        when(repo.existsByEmail("a@a.com")).thenReturn(false);
        when(repo.existsByCpf("12345678901")).thenReturn(true);
        var ex = assertThrows(IllegalArgumentException.class, () -> service.create(req));
        assertTrue(ex.getMessage().toLowerCase().contains("cpf"));
    }

    @Test
    void get_ok(){
        var u = User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build();
        when(repo.findById(1L)).thenReturn(Optional.of(u));
        var res = service.get(1L);
        assertEquals("A", res.nome());
    }

}
