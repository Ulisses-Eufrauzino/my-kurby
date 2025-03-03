<h1>📂 Shaders:</h1>

<h3>📌 Descrição:</h3>
<p>Esta pasta contém shaders personalizados utilizados no jogo para criar efeitos visuais diferenciados, como movimentação de nuvens e variações no ambiente.</p>

<h2>🌍 O que são Singletons na Godot?</h2>
<p>Na Godot, Singletons (também chamados de AutoLoads) são scripts que permanecem carregados durante toda a execução do jogo e podem ser acessados globalmente, sem a necessidade de instanciá-los.</p>

<p>Eles são muito úteis para armazenar e gerenciar informações como:</p>

<ul>
<li>🎮 Estado do jogo (exemplo: pontuação, progresso do jogador, configurações)</li>
<li>🔄 Gerenciamento de cenas (exemplo: troca de fases, carregamento de telas)</li>
<li>📡 Sistemas globais (exemplo: controle de áudio, diálogos, lógica de IA compartilhada)</li>
</ul>

<p>Para adicionar um Singleton (AutoLoad) na Godot:</p>

<ol>
<li>Vá até Projeto > Configurações do Projeto > AutoLoad</li>
<li>Adicione o script desejado e marque a opção Singleton</li>
<li>Agora ele pode ser acessado de qualquer lugar do código usando seu nome</li>
</ol>