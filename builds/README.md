<h1>📂 Themes:</h1>

<h3>📌 Descrição:</h3>
<p>Esta pasta contém arquivos de temas utilizados na interface do jogo. Os temas permitem personalizar a aparência de botões, menus e outros elementos da UI de forma centralizada.</p>

<p>📌 O que você encontrará aqui?,</p>
<ul>
<li>🎛️ (default_btn.tres) – Tema padrão utilizado para botões no jogo.</li>
<li>⏸️ (pause_menu_btn.tres) – Tema específico para os botões do menu de pausa.</li>
</ul>

<h2>🎭 O que são temas na Godot?</h2>
<p>Na Godot, temas são conjuntos de estilos aplicados a controles da interface gráfica (UI), permitindo definir cores, fontes, margens e outros aspectos visuais de maneira unificada.</p>

<p>Eles são especialmente úteis para:</p>

<ul>
<li>🎨 Criar um estilo consistente para o jogo</li>
<li>🛠️ Facilitar mudanças visuais sem editar cada botão manualmente</li>
<li>🔄 Reutilizar configurações de UI em várias cenas</li>
</ul>

<p>Os arquivos de tema na Godot possuem a extensão .tres e podem ser aplicados a qualquer controle UI através do Editor de Temas ou via código.</p>

<h3>📌 Como aplicar um tema na UI?</h3>

<ol>
<li>Selecione um Control (como um botão)</li>
<li>No Inspector, vá até a seção Theme</li>
<li>Carregue um arquivo .tres existente ou crie um novo</li>
</ol>

<p>Também é possível aplicar um tema via código:</p>

var theme = load("res://themes/default_btn.tres")<br>
$Botao.theme = theme