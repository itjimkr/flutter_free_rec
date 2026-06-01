// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Atualizar';

  @override
  String get checkedAccess => 'Acesso verificado.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Ative o Rec nas definições de $label, depois volte à app e toque em Verificar novamente.';
  }

  @override
  String get finishAccessSetup => 'Concluir configuração de acesso';

  @override
  String get screenSettings => 'Definições de Ecrã';

  @override
  String get microphoneSettings => 'Definições de Microfone';

  @override
  String get checkAgain => 'Verificar novamente';

  @override
  String get recordingStarted => 'Gravação iniciada.';

  @override
  String get recordingStopped => 'Gravação parada.';

  @override
  String get guideSummaryNeedsPermission =>
      'O Rec ainda precisa de permissões antes de iniciar a gravação.';

  @override
  String get guideSummaryReadyForContent =>
      'As permissões estão prontas. Agora escolha o que pretende gravar.';

  @override
  String get guideStepAllowScreen =>
      'Toque em Permitir acesso e depois permita a captura de ecrã no aviso do sistema.';

  @override
  String get guideStepScreenSettings =>
      'Toque em Definições de Ecrã e ative o acesso à captura de ecrã para o Rec.';

  @override
  String get guideStepAllowMic =>
      'Se usar Ecrã + Microfone, toque em Permitir quando o sistema pedir acesso ao microfone.';

  @override
  String get guideStepMicSettings =>
      'Toque em Definições de Microfone e ative o acesso ao microfone para o Rec.';

  @override
  String get guideStepPickContent =>
      'Toque em Escolher conteúdo e selecione o ecrã ou a janela que pretende gravar.';

  @override
  String get guideStepCheckAgain =>
      'Volte ao Rec e toque em Verificar novamente.';

  @override
  String get recordHintTurnOnScreen =>
      'Ative a Gravação de ecrã nas Definições';

  @override
  String get recordHintAllowScreen => 'Permita primeiro a Gravação de ecrã';

  @override
  String get recordHintTurnOnMicrophone => 'Ative o Microfone nas Definições';

  @override
  String get recordHintAllowMicrophone => 'Permita primeiro o Microfone';

  @override
  String get recordHintPickContent => 'Escolha o conteúdo a gravar';

  @override
  String get tapToRecord => 'Toque para gravar';

  @override
  String get tapToStop => 'Toque para parar';

  @override
  String get recordAction => 'Iniciar gravação';

  @override
  String get stopAction => 'Parar gravação';

  @override
  String get selectRecordTarget => 'Escolha o que pretende gravar';

  @override
  String get specificProgramRecord => 'Gravar uma aplicação específica';

  @override
  String get fullScreenRecord => 'Gravar o ecrã inteiro';

  @override
  String get specificAreaRecord => 'Gravar uma área específica';

  @override
  String get selectAudioOption => 'Escolha se pretende incluir áudio';

  @override
  String get audioIncluded => 'Gravar com áudio';

  @override
  String get audioExcluded => 'Gravar sem áudio';

  @override
  String get shortcuts => 'Atalhos';

  @override
  String get notReady => 'Não pronto';

  @override
  String get idleState => 'INATIVO';

  @override
  String get recordingState => 'A GRAVAR';

  @override
  String get stoppingState => 'A PARAR';

  @override
  String get screenOnly => 'Só Ecrã';

  @override
  String get screenOnlySublabel => 'Áudio do sistema';

  @override
  String get screenAndMic => 'Ecrã + Microfone';

  @override
  String get screenAndMicSublabel => 'Incluir microfone';

  @override
  String get setup => 'CONFIGURAÇÃO';

  @override
  String get screen => 'Ecrã';

  @override
  String get microphone => 'Microfone';

  @override
  String get ready => 'Pronto';

  @override
  String get openSettings => 'Abrir Definições';

  @override
  String get needsAllow => 'Precisa de permissão';

  @override
  String get optional => 'Opcional';

  @override
  String get screenPermissionDetailReady => 'A captura de ecrã está pronta.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'O Android perguntará o que pretende gravar quando iniciar a gravação.';

  @override
  String get screenPermissionDetailDenied =>
      'Ative o acesso à captura de ecrã para o Rec nas Definições.';

  @override
  String get screenPermissionDetailUnknown =>
      'O sistema perguntará na primeira vez.';

  @override
  String get microphonePermissionDetailReady =>
      'A captura do microfone está ativa.';

  @override
  String get microphonePermissionDetailDenied =>
      'Ative o acesso ao microfone para o Rec nas Definições.';

  @override
  String get microphonePermissionDetailUnknown =>
      'O sistema pedirá permissão se usar Ecrã + Microfone.';

  @override
  String get microphonePermissionDetailOptional =>
      'Necessário apenas para Ecrã + Microfone.';

  @override
  String get beforeYouRecord => 'Antes de gravar';

  @override
  String get allowAccess => 'Permitir acesso';

  @override
  String get pickContent => 'Escolher conteúdo';

  @override
  String get contentSelected => 'Conteúdo selecionado';

  @override
  String get noContentSelected => 'Nenhum conteúdo selecionado';

  @override
  String get clear => 'Limpar';

  @override
  String get change => 'Alterar';

  @override
  String get openInFinder => 'Abrir no Finder';

  @override
  String get openSavedFolder => 'Abrir pasta de gravações';

  @override
  String get video => 'Vídeo';

  @override
  String get frameRate => 'Taxa de fotogramas';

  @override
  String get native => 'Predefinido';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Contentor';

  @override
  String get quality => 'Qualidade';

  @override
  String get qualityLow => 'Baixa';

  @override
  String get qualityMedium => 'Média';

  @override
  String get qualityHigh => 'Alta';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Canal alfa';

  @override
  String get nativeResolution => 'Resolução nativa';

  @override
  String get audio => 'Áudio';

  @override
  String get systemAudio => 'Áudio do sistema';

  @override
  String get micDevice => 'Dispositivo de microfone';

  @override
  String get systemDefault => 'Predefinição do sistema';

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String get display => 'Ecrã';

  @override
  String get showCursor => 'Mostrar cursor';

  @override
  String get showWallpaper => 'Mostrar fundo';

  @override
  String get showMenuBar => 'Mostrar barra de menu';

  @override
  String get showDock => 'Mostrar Dock';

  @override
  String get showRecorderUi => 'Mostrar interface do gravador';

  @override
  String get windowShadows => 'Sombras da janela';

  @override
  String get presenterOverlay => 'Sobreposição do apresentador';

  @override
  String get enableOverlay => 'Ativar sobreposição';

  @override
  String get camera => 'Câmara';

  @override
  String get capabilities => 'FUNCIONALIDADES';

  @override
  String get capabilityContentPicker => 'Seletor de conteúdo';

  @override
  String get capabilityAreaSelection => 'Seleção de área';

  @override
  String get capabilityPresenterOverlay => 'Sobreposição do apresentador';

  @override
  String get capabilitySystemAudio => 'Áudio do sistema';

  @override
  String get capabilityMicrophone => 'Microfone';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Filtragem de janelas';

  @override
  String get settings => 'Configurações';

  @override
  String get general => 'Geral';

  @override
  String get language => 'Idioma';

  @override
  String get autoRefresh => 'Atualização automática';

  @override
  String get refreshInterval => 'Intervalo de atualização';

  @override
  String get recordingDefaults => 'Padrões de gravação';

  @override
  String get accessAndStorage => 'Acesso e armazenamento';

  @override
  String get advancedControls => 'Controles avançados';

  @override
  String get pausedState => 'EM PAUSA';

  @override
  String get pauseAction => 'Pausar';

  @override
  String get resumeAction => 'Retomar';

  @override
  String get countdown => 'Contagem decrescente';

  @override
  String get countdownState => 'A começar em';

  @override
  String get recentRecordings => 'Gravações recentes';

  @override
  String get audioSystemOnly => 'Apenas áudio do sistema';

  @override
  String get audioMicrophoneOnly => 'Apenas microfone';

  @override
  String get audioSystemAndMicrophone => 'Áudio do sistema + Microfone';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Rec';

  @override
  String get refresh => 'Atualizar';

  @override
  String get checkedAccess => 'Acesso verificado.';

  @override
  String turnOnRecInSettings(Object label) {
    return 'Ative o Rec nas configurações de $label, depois volte ao app e toque em Verificar Novamente.';
  }

  @override
  String get finishAccessSetup => 'Concluir configuração de acesso';

  @override
  String get screenSettings => 'Configurações de Tela';

  @override
  String get microphoneSettings => 'Configurações de Microfone';

  @override
  String get checkAgain => 'Verificar Novamente';

  @override
  String get recordingStarted => 'Gravação iniciada.';

  @override
  String get recordingStopped => 'Gravação interrompida.';

  @override
  String get guideSummaryNeedsPermission =>
      'O Rec ainda precisa de permissões antes de iniciar a gravação.';

  @override
  String get guideSummaryReadyForContent =>
      'As permissões estão prontas. Agora escolha o que deseja gravar.';

  @override
  String get guideStepAllowScreen =>
      'Toque em Permitir Acesso e depois permita a captura de tela no aviso do sistema.';

  @override
  String get guideStepScreenSettings =>
      'Toque em Configurações de Tela e ative o acesso de captura de tela para o Rec.';

  @override
  String get guideStepAllowMic =>
      'Se você usar Tela + Microfone, toque em Permitir quando o sistema pedir acesso ao microfone.';

  @override
  String get guideStepMicSettings =>
      'Toque em Configurações de Microfone e ative o acesso ao microfone para o Rec.';

  @override
  String get guideStepPickContent =>
      'Toque em Escolher Conteúdo e selecione a tela ou janela que deseja gravar.';

  @override
  String get guideStepCheckAgain =>
      'Volte ao Rec e toque em Verificar Novamente.';

  @override
  String get recordHintTurnOnScreen =>
      'Ative a Gravação de Tela nas Configurações';

  @override
  String get recordHintAllowScreen => 'Permita a Gravação de Tela primeiro';

  @override
  String get recordHintTurnOnMicrophone =>
      'Ative o Microfone nas Configurações';

  @override
  String get recordHintAllowMicrophone => 'Permita o Microfone primeiro';

  @override
  String get recordHintPickContent => 'Escolha o conteúdo para gravar';

  @override
  String get tapToRecord => 'Toque para gravar';

  @override
  String get tapToStop => 'Toque para parar';

  @override
  String get recordAction => 'Iniciar gravação';

  @override
  String get stopAction => 'Parar gravação';

  @override
  String get selectRecordTarget => 'Escolha o que você quer gravar';

  @override
  String get specificProgramRecord => 'Gravar um app específico';

  @override
  String get fullScreenRecord => 'Gravar a tela inteira';

  @override
  String get specificAreaRecord => 'Gravar uma área específica';

  @override
  String get selectAudioOption => 'Escolha se quer incluir áudio';

  @override
  String get audioIncluded => 'Gravar com áudio';

  @override
  String get audioExcluded => 'Gravar sem áudio';

  @override
  String get shortcuts => 'Atalhos';

  @override
  String get notReady => 'Não pronto';

  @override
  String get idleState => 'INATIVO';

  @override
  String get recordingState => 'GRAVANDO';

  @override
  String get stoppingState => 'PARANDO';

  @override
  String get screenOnly => 'Somente Tela';

  @override
  String get screenOnlySublabel => 'Áudio do sistema';

  @override
  String get screenAndMic => 'Tela + Microfone';

  @override
  String get screenAndMicSublabel => 'Incluir microfone';

  @override
  String get setup => 'CONFIGURAÇÃO';

  @override
  String get screen => 'Tela';

  @override
  String get microphone => 'Microfone';

  @override
  String get ready => 'Pronto';

  @override
  String get openSettings => 'Abrir Configurações';

  @override
  String get needsAllow => 'Precisa permitir';

  @override
  String get optional => 'Opcional';

  @override
  String get screenPermissionDetailReady => 'A captura de tela está pronta.';

  @override
  String get screenPermissionDetailPromptOnStart =>
      'No Android, será perguntado o que você quer gravar ao iniciar a gravação.';

  @override
  String get screenPermissionDetailDenied =>
      'Ative o acesso de captura de tela para o Rec nas Configurações.';

  @override
  String get screenPermissionDetailUnknown =>
      'O sistema perguntará na primeira vez.';

  @override
  String get microphonePermissionDetailReady =>
      'A captura do microfone está ativada.';

  @override
  String get microphonePermissionDetailDenied =>
      'Ative o acesso ao microfone para o Rec nas Configurações.';

  @override
  String get microphonePermissionDetailUnknown =>
      'O sistema perguntará se você usar Tela + Microfone.';

  @override
  String get microphonePermissionDetailOptional =>
      'Necessário apenas para Tela + Microfone.';

  @override
  String get beforeYouRecord => 'Antes de gravar';

  @override
  String get allowAccess => 'Permitir Acesso';

  @override
  String get pickContent => 'Escolher Conteúdo';

  @override
  String get contentSelected => 'Conteúdo selecionado';

  @override
  String get noContentSelected => 'Nenhum conteúdo selecionado';

  @override
  String get clear => 'Limpar';

  @override
  String get change => 'Alterar';

  @override
  String get openInFinder => 'Abrir no Finder';

  @override
  String get openSavedFolder => 'Abrir pasta de gravações';

  @override
  String get video => 'Vídeo';

  @override
  String get frameRate => 'Taxa de Quadros';

  @override
  String get native => 'Padrão';

  @override
  String get codec => 'Codec';

  @override
  String get container => 'Contêiner';

  @override
  String get quality => 'Qualidade';

  @override
  String get qualityLow => 'Baixa';

  @override
  String get qualityMedium => 'Média';

  @override
  String get qualityHigh => 'Alta';

  @override
  String get hdr => 'HDR';

  @override
  String get alphaChannel => 'Canal Alfa';

  @override
  String get nativeResolution => 'Resolução Nativa';

  @override
  String get audio => 'Áudio';

  @override
  String get systemAudio => 'Áudio do Sistema';

  @override
  String get micDevice => 'Dispositivo de Microfone';

  @override
  String get systemDefault => 'Padrão do Sistema';

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String get display => 'Tela';

  @override
  String get showCursor => 'Mostrar Cursor';

  @override
  String get showWallpaper => 'Mostrar Papel de Parede';

  @override
  String get showMenuBar => 'Mostrar Barra de Menu';

  @override
  String get showDock => 'Mostrar Dock';

  @override
  String get showRecorderUi => 'Mostrar UI do Gravador';

  @override
  String get windowShadows => 'Sombras da Janela';

  @override
  String get presenterOverlay => 'Sobreposição do Apresentador';

  @override
  String get enableOverlay => 'Ativar Sobreposição';

  @override
  String get camera => 'Câmera';

  @override
  String get capabilities => 'RECURSOS';

  @override
  String get capabilityContentPicker => 'Seletor de Conteúdo';

  @override
  String get capabilityAreaSelection => 'Seleção de Área';

  @override
  String get capabilityPresenterOverlay => 'Sobreposição do Apresentador';

  @override
  String get capabilitySystemAudio => 'Áudio do Sistema';

  @override
  String get capabilityMicrophone => 'Microfone';

  @override
  String get capabilityHdr => 'HDR';

  @override
  String get capabilityAlpha => 'Alfa';

  @override
  String get capabilityWindowFiltering => 'Filtragem de Janela';

  @override
  String get settings => 'Configurações';

  @override
  String get general => 'Geral';

  @override
  String get language => 'Idioma';

  @override
  String get autoRefresh => 'Atualização automática';

  @override
  String get refreshInterval => 'Intervalo de atualização';

  @override
  String get recordingDefaults => 'Padrões de gravação';

  @override
  String get accessAndStorage => 'Acesso e armazenamento';

  @override
  String get advancedControls => 'Controles avançados';

  @override
  String get pausedState => 'EM PAUSA';

  @override
  String get pauseAction => 'Pausar';

  @override
  String get resumeAction => 'Retomar';

  @override
  String get countdown => 'Contagem regressiva';

  @override
  String get countdownState => 'Começa em';

  @override
  String get recentRecordings => 'Gravações recentes';

  @override
  String get audioSystemOnly => 'Somente áudio do sistema';

  @override
  String get audioMicrophoneOnly => 'Somente microfone';

  @override
  String get audioSystemAndMicrophone => 'Som do sistema + Microfone';
}
