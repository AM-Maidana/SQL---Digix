var builder = WebApplication.CreateBuilder(args);

// String de conexão com o PostgreSQL
var connectionString = "Host=localhost;Database=BDConexao;Username=postgres;Password=1234";

// Adicione o DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

var app = builder.Build();

// Configuração da pipeline de requisições HTTP...
app.MapControllers();

app.Run();
