package br.com.fiap.skillbridge.ai.matricula.service;

import br.com.fiap.skillbridge.ai.matricula.dto.MatriculaRequest;
import br.com.fiap.skillbridge.ai.matricula.dto.MatriculaResponse;
import br.com.fiap.skillbridge.ai.matricula.model.Matricula;
import br.com.fiap.skillbridge.ai.matricula.repository.MatriculaRepository;
import br.com.fiap.skillbridge.ai.shared.exception.NotFoundException;
import br.com.fiap.skillbridge.ai.trilha.model.Trilha;
import br.com.fiap.skillbridge.ai.trilha.repository.TrilhaRepository;
import br.com.fiap.skillbridge.ai.user.model.User;
import br.com.fiap.skillbridge.ai.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MatriculaServiceTest {

    @Mock MatriculaRepository repo;
    @Mock UserRepository userRepo;
    @Mock TrilhaRepository trilhaRepo;
    @InjectMocks MatriculaService service;

    @Test
    void create_ok_salvaEMapeiaCorretamente() {
        var user   = User.builder()
                .id(1L).nome("Abner").email("abner@fiap.com").cpf("12345678901")
                .build();
        var trilha = Trilha.builder()
                .id(2L).titulo("SkillBridge Java")
                .build();

        when(userRepo.findById(1L)).thenReturn(Optional.of(user));
        when(trilhaRepo.findById(2L)).thenReturn(Optional.of(trilha));
        when(repo.existsByUser_IdAndTrilha_Id(1L, 2L)).thenReturn(false);

        when(repo.save(any(Matricula.class))).thenAnswer(inv -> {
            Matricula m = inv.getArgument(0);
            m.setId(10L);
            // se o service não seta criadaEm, pode tirar isso
            if (m.getCriadaEm() == null) {
                m.setCriadaEm(LocalDateTime.now());
            }
            return m;
        });

        MatriculaResponse resp = service.create(new MatriculaRequest(1L, 2L));

        assertNotNull(resp);
        assertEquals(10L, resp.id());
        assertEquals(1L, resp.userId());
        assertEquals("Abner", resp.userNome());
        assertEquals(2L, resp.trilhaId());
        assertEquals("SkillBridge Java", resp.trilhaTitulo());
        assertNotNull(resp.criadaEm());

        verify(repo).save(any(Matricula.class));
    }

    @Test
    void create_ok(){
        var req = new MatriculaRequest(1L, 2L);
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("Abner").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(2L)).thenReturn(Optional.of(Trilha.builder().id(2L).titulo("Java").build()));
        when(repo.existsByUser_IdAndTrilha_Id(1L,2L)).thenReturn(false);
        when(repo.save(any())).thenAnswer(a -> { Matricula m=a.getArgument(0); m.setId(10L); return m; });

        var res = service.create(req);
        assertEquals(10L, res.id());
        assertEquals(1L, res.userId());
        assertEquals(2L, res.trilhaId());
    }

    @Test
    void create_userNotFound(){
        var req = new MatriculaRequest(99L, 1L);
        when(userRepo.findById(99L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> service.create(req));
    }

    @Test
    void delete_notFound(){
        when(repo.existsById(77L)).thenReturn(false);
        assertThrows(NotFoundException.class, () -> service.delete(77L));
    }

    @Test
    void create_trilhaNotFound(){
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(9L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> service.create(new MatriculaRequest(1L,9L)));
    }

    @Test
    void create_duplicado_badRequest(){
        when(userRepo.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).nome("A").email("a@a.com").cpf("12345678901").build()));
        when(trilhaRepo.findById(2L)).thenReturn(Optional.of(Trilha.builder().id(2L).titulo("T").build()));
        when(repo.existsByUser_IdAndTrilha_Id(1L,2L)).thenReturn(true);
        var req = new MatriculaRequest(1L, 2L);
        assertThrows(IllegalArgumentException.class, () -> service.create(req));
    }

    @Test
    void delete_ok(){
        when(repo.existsById(5L)).thenReturn(true);
        service.delete(5L);
        verify(repo).deleteById(5L);
    }

    @Test
    void delete_notFound_lancaNotFoundException() {
        when(repo.existsById(99L)).thenReturn(false);

        assertThrows(NotFoundException.class, () -> service.delete(99L));

        verify(repo, never()).deleteById(anyLong());
    }

    @Test
    void list_quandoUserETrilhaPreenchidos_buscaPorUserETrilha() {
        var user = User.builder().id(1L).nome("User").build();
        var trilha = Trilha.builder().id(2L).titulo("Trilha").build();
        var m = new Matricula();
        m.setId(10L);
        m.setUser(user);
        m.setTrilha(trilha);

        when(repo.findByUser_IdAndTrilha_Id(1L, 2L)).thenReturn(List.of(m));

        var result = service.list(1L, 2L);

        assertEquals(1, result.size());
        verify(repo).findByUser_IdAndTrilha_Id(1L, 2L);
    }

    @Test
    void list_quandoSoUser_buscaPorUser() {
        var user = User.builder().id(1L).nome("User").build();
        var trilha = Trilha.builder().id(2L).titulo("Trilha").build();
        var m = new Matricula();
        m.setId(11L);
        m.setUser(user);
        m.setTrilha(trilha);

        when(repo.findByUser_Id(1L)).thenReturn(List.of(m));

        var result = service.list(1L, null);

        assertEquals(1, result.size());
        verify(repo).findByUser_Id(1L);
    }

    @Test
    void list_quandoSoTrilha_buscaPorTrilha() {
        var user = User.builder().id(1L).nome("User").build();
        var trilha = Trilha.builder().id(2L).titulo("Trilha").build();
        var m = new Matricula();
        m.setId(12L);
        m.setUser(user);
        m.setTrilha(trilha);

        when(repo.findByTrilha_Id(2L)).thenReturn(List.of(m));

        var result = service.list(null, 2L);

        assertEquals(1, result.size());
        verify(repo).findByTrilha_Id(2L);
    }

    @Test
    void list_semFiltros_buscaTodos() {
        var user = User.builder().id(1L).nome("User").build();
        var trilha = Trilha.builder().id(2L).titulo("Trilha").build();
        var m = new Matricula();
        m.setId(13L);
        m.setUser(user);
        m.setTrilha(trilha);

        when(repo.findAll()).thenReturn(List.of(m));

        var result = service.list(null, null);

        assertEquals(1, result.size());
        verify(repo).findAll();
    }

}
