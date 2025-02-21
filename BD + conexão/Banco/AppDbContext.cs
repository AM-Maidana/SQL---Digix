using Microsoft.EntityFrameworkCore;

public class AppDbContext : DbContext
{
    // Defina as DbSets (tabelas) que você quer acessar
    public DbSet<Usuario> Usuarios { get; set; }
    public DbSet<Maquina> Maquinas { get; set; }

    // Este é o método que configura a conexão com o banco
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        // Coloque a sua string de conexão com o PostgreSQL aqui
        optionsBuilder.UseNpgsql("Host=localhost;Database=BDConexao;Username=postgres;Password=1234");
    }
}
