import 'package:flutter/material.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/screens/learning/quiz_screen.dart';

/// Type of a lesson content card (drives its icon/color in the UI).
enum CardType { concept, example, funFact, tip }

class LessonCard {
  final CardType type;
  final String title;
  final String body;
  const LessonCard(this.type, this.title, this.body);
}

enum PracticeType { none, coding, electronics }

class Lesson {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final List<LessonCard> cards;
  final List<QuizQuestionData> questions;
  final PracticeType practiceType;
  final String? challengeId;

  const Lesson({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.cards,
    required this.questions,
    this.practiceType = PracticeType.none,
    this.challengeId,
  });
}

/// A STEM learning area the child can choose (replaces the old ranks).
class StemArea {
  final String id;
  final String name;
  final String tagline;
  final IconData icon;
  final Color color;
  final List<Lesson> lessons;

  const StemArea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.color,
    required this.lessons,
  });
}

StemArea areaById(String id) => stemAreas.firstWhere((a) => a.id == id, orElse: () => stemAreas.first);

// Shorthands.
const _c = CardType.concept;
const _e = CardType.example;
const _f = CardType.funFact;
const _t = CardType.tip;
QuizQuestionData _q(String id, String q, List<String> o, int c, String e) =>
    QuizQuestionData(id: id, question: q, options: o, correct: c, explanation: e);

final List<StemArea> stemAreas = [
  // ==========================================================================
  // ROBÓTICA
  // ==========================================================================
  StemArea(
    id: 'robotica',
    name: 'Robótica',
    tagline: 'Construye y controla robots',
    icon: Icons.smart_toy_rounded,
    color: AppTheme.accentPurple,
    lessons: [
      Lesson(
        id: 'rob1',
        emoji: '🤖',
        title: '¿Qué es un robot?',
        subtitle: 'Descubre qué hace especial a un robot',
        practiceType: PracticeType.coding,
        challengeId: 'c1',
        cards: [
          LessonCard(_c, '¿Qué es un robot?',
              'Un robot es una máquina que puede sentir, pensar y actuar. Capta información con sus sensores, decide qué hacer con su "cerebro" (controlador) y se mueve con sus motores.'),
          LessonCard(_e, 'Robots a tu alrededor',
              'Una aspiradora que esquiva muebles, un brazo que arma autos y un rover que explora Marte son todos robots: sienten, deciden y actúan.'),
          LessonCard(_f, '¿Sabías que…?',
              'La palabra "robot" viene de "robota", que en checo significa "trabajo". ¡Se usó por primera vez en una obra de teatro en 1920!'),
        ],
        questions: [
          _q('rq1', 'Las 3 cosas que hace un robot son: sentir, pensar y…', ['comer', 'actuar', 'dormir', 'hablar'], 1,
              'Un robot siente con sensores, piensa con su controlador y actúa con sus motores.'),
          _q('rq2', '¿Qué parte del robot capta información del entorno?', ['El motor', 'El sensor', 'La batería', 'La rueda'], 1,
              'Los sensores detectan luz, distancia, sonido, etc.'),
          _q('rq3', '¿Cuál de estos es un robot?', ['Una silla', 'Un rover de Marte', 'Un libro', 'Una pelota'], 1,
              'El rover siente, decide y se mueve solo: es un robot.'),
          _q('rq4', 'El "cerebro" de un robot también se llama…', ['controlador', 'antena', 'engranaje', 'chasis'], 0,
              'El controlador procesa la información y decide qué hacer.'),
          _q('rq5', '¿De qué idioma viene la palabra "robot"?', ['Inglés', 'Checo', 'Latín', 'Japonés'], 1,
              '"Robota" significa "trabajo" en checo.'),
        ],
      ),
      Lesson(
        id: 'rob2',
        emoji: '🦾',
        title: 'Partes de un robot',
        subtitle: 'Conoce el cuerpo de tu robot',
        practiceType: PracticeType.coding,
        challengeId: 'c2',
        cards: [
          LessonCard(_c, 'Las partes principales',
              'Casi todos los robots tienen: estructura (chasis), sensores (sentidos), actuadores (motores que mueven), controlador (cerebro) y una fuente de energía (batería).'),
          LessonCard(_e, 'Ejemplo: un rover',
              'El chasis sostiene todo, las ruedas y motores lo mueven, el sensor ultrasónico mide distancia y la batería le da energía.'),
          LessonCard(_t, 'Tip',
              'Si tu robot no se mueve, revisa primero la batería y las conexiones de los motores.'),
        ],
        questions: [
          _q('rq6', '¿Qué parte sostiene y conecta todas las piezas?', ['El chasis', 'El sensor', 'La antena', 'El LED'], 0,
              'El chasis es la estructura del robot.'),
          _q('rq7', 'Los actuadores sirven para…', ['medir', 'mover', 'iluminar', 'guardar datos'], 1,
              'Los actuadores (motores) producen movimiento.'),
          _q('rq8', '¿Qué le da energía al robot?', ['La batería', 'El chasis', 'El tornillo', 'La rueda'], 0,
              'La batería almacena la energía eléctrica.'),
          _q('rq9', 'Un sensor ultrasónico sirve para…', ['medir distancia', 'dar color', 'sumar', 'cargar la pila'], 0,
              'Mide distancia usando ecos de sonido, como un murciélago.'),
          _q('rq10', 'Si el robot no se mueve, primero revisa…', ['el color', 'la batería y conexiones', 'el nombre', 'el tamaño'], 1,
              'Sin energía o con un cable suelto, los motores no funcionan.'),
        ],
      ),
      Lesson(
        id: 'rob3',
        emoji: '🎮',
        title: 'Cómo se mueve un robot',
        subtitle: 'Motores, ruedas y control',
        practiceType: PracticeType.coding,
        challengeId: 'c3',
        cards: [
          LessonCard(_c, 'Del comando al movimiento',
              'Tú das una orden, el controlador la recibe y envía electricidad a los motores. Los motores giran las ruedas y… ¡el robot avanza!'),
          LessonCard(_f, 'Giros inteligentes',
              'Para girar, un robot con dos ruedas puede mover una rueda más rápido que la otra. ¡Así cambia de dirección sin volante!'),
        ],
        questions: [
          _q('rq11', 'El motor convierte electricidad en…', ['luz', 'movimiento', 'sonido', 'calor'], 1,
              'El motor transforma energía eléctrica en movimiento.'),
          _q('rq12', 'Para que un robot de 2 ruedas gire, puede…', ['apagarse', 'mover una rueda más rápido', 'subir el volumen', 'cambiar de color'], 1,
              'Diferentes velocidades en cada rueda producen el giro.'),
          _q('rq13', '¿Quién envía la orden a los motores?', ['el controlador', 'la rueda', 'el LED', 'la antena'], 0,
              'El controlador (cerebro) decide y envía las señales.'),
          _q('rq14', 'Una rueda más grande, por cada vuelta…', ['avanza más', 'avanza menos', 'no avanza', 'gira al revés'], 0,
              'Mayor diámetro cubre más distancia por vuelta.'),
        ],
      ),
      Lesson(
        id: 'rob4',
        emoji: '🦇',
        title: 'Sensores del robot',
        subtitle: 'Los sentidos de tu robot',
        practiceType: PracticeType.coding,
        challengeId: 'c4',
        cards: [
          LessonCard(_c, '¿Qué es un sensor?',
              'Un sensor es un "sentido" del robot: detecta luz, distancia, sonido, temperatura o el tacto, y le envía esa información a su cerebro para decidir qué hacer.'),
          LessonCard(_e, 'Sensor ultrasónico',
              'Mide la distancia a un objeto rebotando sonido, como un murciélago. Así el robot sabe cuándo hay una pared y la esquiva.'),
          LessonCard(_f, '¿Sabías que…?',
              'Un robot puede tener muchos sensores a la vez: ojos (cámara), oídos (micrófono) y hasta "piel" (sensores de tacto).'),
        ],
        questions: [
          _q('rq15', '¿Para qué sirven los sensores?', ['decorar', 'captar información del entorno', 'dar energía', 'pintar'], 1,
              'Los sensores detectan lo que pasa alrededor del robot.'),
          _q('rq16', 'El sensor ultrasónico mide…', ['distancia', 'color', 'peso', 'tiempo'], 0,
              'Mide distancia usando ecos de sonido.'),
          _q('rq17', 'Un sensor envía la información al…', ['cerebro (controlador)', 'motor', 'chasis', 'LED'], 0,
              'El controlador recibe los datos y decide.'),
          _q('rq18', 'Para esquivar una pared, el robot usa un sensor de…', ['distancia', 'sabor', 'música', 'color'], 0,
              'Detecta qué tan cerca está la pared.'),
        ],
      ),
      Lesson(
        id: 'rob5',
        emoji: '🌎',
        title: 'Robots en el mundo real',
        subtitle: '¿Dónde viven los robots?',
        practiceType: PracticeType.coding,
        challengeId: 'c2',
        cards: [
          LessonCard(_c, 'Robots por todas partes',
              'Hay robots en fábricas (arman autos), hospitales (ayudan en cirugías), el campo (cosechan) y el espacio (exploran planetas).'),
          LessonCard(_e, 'Ejemplos cotidianos',
              'Una aspiradora robot limpia sola, un dron vuela y toma fotos, y un brazo robótico suelda piezas sin cansarse.'),
          LessonCard(_f, '¿Sabías que…?',
              'El robot "Perseverance" explora Marte desde 2021 buscando señales de vida antigua. 🚀'),
        ],
        questions: [
          _q('rq19', 'Verdadero o Falso: los robots solo existen en las películas.', ['Verdadero', 'Falso'], 1,
              'Falso: hay robots reales en fábricas, hospitales, el campo y el espacio.'),
          _q('rq20', '¿Dónde NO suele haber robots?', ['fábricas', 'hospitales', 'el espacio', 'en los sueños'], 3,
              'Los robots son máquinas reales, no aparecen en los sueños.'),
          _q('rq21', 'Un dron es un robot que…', ['vuela', 'cocina', 'duerme', 'canta'], 0,
              'Los drones son robots voladores.'),
          _q('rq22', 'Verdadero o Falso: un robot puede trabajar sin cansarse.', ['Verdadero', 'Falso'], 0,
              'Verdadero: por eso ayudan en trabajos repetitivos.'),
          _q('rq23', 'El robot que explora Marte se llama…', ['Perseverance', 'Pikachu', 'Nemo', 'Messi'], 0,
              'Perseverance explora Marte desde 2021.'),
        ],
      ),
    ],
  ),

  // ==========================================================================
  // PROGRAMACIÓN
  // ==========================================================================
  StemArea(
    id: 'programacion',
    name: 'Programación',
    tagline: 'Dale órdenes a la computadora',
    icon: Icons.code_rounded,
    color: AppTheme.primaryBlue,
    lessons: [
      Lesson(
        id: 'prg1',
        emoji: '📝',
        title: 'Secuencias y pasos',
        subtitle: 'El orden importa',
        practiceType: PracticeType.coding,
        challengeId: 'c1',
        cards: [
          LessonCard(_c, '¿Qué es un programa?',
              'Un programa es una lista de instrucciones en orden. La computadora hace exactamente lo que le dices, paso a paso.'),
          LessonCard(_e, 'Receta = programa',
              'Hacer un sándwich tiene pasos en orden: 1) toma el pan, 2) pon el relleno, 3) cierra. Si cambias el orden… ¡sale mal!'),
          LessonCard(_t, 'Tip',
              'Cuando algo no funciona, lee tus pasos en orden, como lo haría la computadora.'),
        ],
        questions: [
          _q('pq1', 'Un programa es…', ['un dibujo', 'una lista de instrucciones en orden', 'una pila', 'un robot'], 1,
              'Es una secuencia ordenada de instrucciones.'),
          _q('pq2', 'Si cambias el orden de los pasos…', ['da igual', 'el resultado puede cambiar', 'se borra', 'va más rápido'], 1,
              'En programación el orden importa muchísimo.'),
          _q('pq3', '¿Qué es lo más parecido a un programa?', ['una receta de cocina', 'una nube', 'una piedra', 'un color'], 0,
              'Una receta son pasos en orden, igual que un programa.'),
          _q('pq4', 'La computadora hace…', ['lo que quiere', 'exactamente lo que le dices', 'nada', 'lo contrario'], 1,
              'Sigue tus instrucciones al pie de la letra.'),
        ],
      ),
      Lesson(
        id: 'prg2',
        emoji: '🔁',
        title: 'Bucles (Loops)',
        subtitle: 'Repetir sin cansarse',
        practiceType: PracticeType.coding,
        challengeId: 'c2',
        cards: [
          LessonCard(_c, '¿Qué es un bucle?',
              'Un bucle (loop) repite instrucciones varias veces sin tener que escribirlas una por una. Por ejemplo: "avanza 4 veces".'),
          LessonCard(_e, 'Bailar en bucle',
              'En vez de escribir "aplaude, aplaude, aplaude, aplaude", dices "repite 4 veces: aplaude". ¡Más corto y claro!'),
          LessonCard(_f, '¿Sabías que…?',
              'Los bucles ahorran muchísimo trabajo: un programa de 3 líneas con un bucle puede hacer miles de repeticiones.'),
        ],
        questions: [
          _q('pq5', 'Un bucle sirve para…', ['borrar', 'repetir instrucciones', 'apagar', 'pintar'], 1,
              'Repite un bloque de instrucciones varias veces.'),
          _q('pq6', '"Repite 3 veces: salta" hará que saltes…', ['1 vez', '3 veces', '0 veces', 'para siempre'], 1,
              'El bucle repite la acción 3 veces.'),
          _q('pq7', '¿Por qué usar bucles?', ['para escribir menos y repetir', 'para gastar batería', 'para confundir', 'no sirven'], 0,
              'Ahorran escritura y hacen el código más claro.'),
          _q('pq8', '¿Cuál NO es un buen uso de un bucle?', ['mover 10 pasos uno a uno', 'repetir 10 veces: avanza', 'dibujar 5 cuadrados iguales', 'parpadear un LED 8 veces'], 0,
              'Hacerlo uno por uno es justo lo que el bucle evita.'),
        ],
      ),
      Lesson(
        id: 'prg3',
        emoji: '🔀',
        title: 'Condicionales',
        subtitle: 'Tomar decisiones',
        practiceType: PracticeType.coding,
        challengeId: 'c4',
        cards: [
          LessonCard(_c, 'Si… entonces…',
              'Una condicional permite decidir: "SI hay un obstáculo, ENTONCES gira". El programa elige según lo que pasa.'),
          LessonCard(_e, '¿Llevo paraguas?',
              'SI está lloviendo, ENTONCES llevo paraguas; SI NO, lo dejo en casa. ¡Así decide tu programa!'),
        ],
        questions: [
          _q('pq9', 'Una condicional sirve para…', ['repetir', 'tomar decisiones', 'sumar', 'apagar'], 1,
              'Decide entre caminos según una condición.'),
          _q('pq10', '"SI hay pared, ENTONCES gira" hará girar al robot…', ['siempre', 'solo si hay pared', 'nunca', 'al azar'], 1,
              'La acción ocurre solo si se cumple la condición.'),
          _q('pq11', 'La palabra clave de una condicional es…', ['SI (if)', 'REPITE', 'FIN', 'COLOR'], 0,
              '"SI" (if) inicia la decisión.'),
          _q('pq12', '¿Qué decide una condicional?', ['el color del robot', 'qué camino tomar', 'el tamaño', 'la batería'], 1,
              'Elige qué hacer según la situación.'),
        ],
      ),
      Lesson(
        id: 'prg4',
        emoji: '📦',
        title: 'Variables',
        subtitle: 'Cajitas que guardan datos',
        practiceType: PracticeType.coding,
        challengeId: 'c3',
        cards: [
          LessonCard(_c, '¿Qué es una variable?',
              'Una variable es como una cajita con nombre donde guardas un dato (un número o un texto). Puedes leerlo o cambiarlo cuando quieras.'),
          LessonCard(_e, 'Contar puntos',
              'Si guardas puntos = 0 y ganas, haces puntos = puntos + 1. ¡La cajita ahora vale 1!'),
          LessonCard(_t, 'Tip',
              'Usa nombres claros para tus variables: "vidas", "velocidad", "puntos"… así entiendes tu código.'),
        ],
        questions: [
          _q('pq13', 'Una variable sirve para…', ['guardar un dato con nombre', 'borrar el código', 'apagar', 'girar'], 0,
              'Es una cajita con nombre que guarda información.'),
          _q('pq14', 'Si puntos = 5 y haces puntos = puntos + 2, ahora vale…', ['7', '5', '2', '52'], 0,
              '5 + 2 = 7.'),
          _q('pq15', '¿Cuál es un buen nombre de variable?', ['velocidad', 'x@1', '(vacío)', '???'], 0,
              'Un nombre claro describe qué guarda.'),
          _q('pq16', '¿Puedes cambiar el valor de una variable?', ['sí, cuando quieras', 'no, nunca', 'solo una vez', 'solo si llueve'], 0,
              'Por eso se llama "variable": su valor puede variar.'),
        ],
      ),
      Lesson(
        id: 'prg5',
        emoji: '🐞',
        title: 'Encontrar errores (bugs)',
        subtitle: 'Aprende a depurar tu código',
        practiceType: PracticeType.coding,
        challengeId: 'c4',
        cards: [
          LessonCard(_c, '¿Qué es un bug?',
              'Un "bug" es un error en el programa. "Depurar" (debug) es buscar y corregir esos errores para que todo funcione bien.'),
          LessonCard(_e, 'Detective de código',
              'Si el robot debía avanzar 3 y avanzó 2, revisa tus bloques: quizá falta uno. ¡Encontrarlo es depurar!'),
          LessonCard(_t, 'Tip',
              'Lee tu código paso a paso, como lo haría la computadora, para ver dónde se equivoca.'),
        ],
        questions: [
          _q('pq17', 'Un bug es…', ['un error en el programa', 'un premio', 'un robot', 'una pila'], 0,
              'Un bug es un fallo en el código.'),
          _q('pq18', 'Depurar (debug) significa…', ['buscar y corregir errores', 'borrar todo', 'apagar', 'pintar'], 0,
              'Es encontrar y arreglar los bugs.'),
          _q('pq19', 'Verdadero o Falso: hasta los mejores programadores cometen bugs.', ['Verdadero', 'Falso'], 0,
              'Verdadero: equivocarse y corregir es parte de programar.'),
          _q('pq20', 'Para encontrar un bug conviene…', ['leer el código paso a paso', 'adivinar', 'rendirse', 'gritar'], 0,
              'Revisar con calma, paso a paso.'),
          _q('pq21', 'Si tu robot hace algo raro, primero…', ['revisas tus instrucciones', 'tiras la tablet', 'lo apagas para siempre', 'no haces nada'], 0,
              'El error casi siempre está en las instrucciones.'),
        ],
      ),
    ],
  ),

  // ==========================================================================
  // ELECTRÓNICA  (con práctica en el simulador)
  // ==========================================================================
  StemArea(
    id: 'electronica',
    name: 'Electrónica',
    tagline: 'Circuitos, luces y energía',
    icon: Icons.bolt_rounded,
    color: AppTheme.accentCyan,
    lessons: [
      Lesson(
        id: 'ele1',
        emoji: '🔌',
        title: 'Circuitos eléctricos',
        subtitle: 'El camino de la corriente',
        practiceType: PracticeType.electronics,
        challengeId: 'e1',
        cards: [
          LessonCard(_c, '¿Qué es un circuito?',
              'Un circuito es un camino cerrado por donde viaja la corriente eléctrica, desde la pila, por los cables y de regreso.'),
          LessonCard(_e, 'Abierto vs. cerrado',
              'Si el camino está completo (cerrado), la corriente fluye y el LED enciende. Si hay un corte (abierto), no pasa nada.'),
          LessonCard(_t, 'Práctica',
              '¡Arma tu propio circuito en el Simulador! Conecta una pila y un LED para encender la luz.'),
        ],
        questions: [
          _q('eq1', 'La corriente fluye cuando el circuito está…', ['abierto', 'cerrado', 'roto', 'frío'], 1,
              'Necesita un camino cerrado y completo.'),
          _q('eq2', '¿Qué componente da energía al circuito?', ['la pila', 'el LED', 'el cable', 'el interruptor'], 0,
              'La pila o batería entrega la energía.'),
          _q('eq3', 'Un interruptor sirve para…', ['medir', 'abrir o cerrar el paso', 'dar color', 'sumar'], 1,
              'Abre (corta) o cierra (permite) la corriente.'),
          _q('eq4', 'Si el LED no enciende, puede ser que el circuito esté…', ['cerrado', 'abierto', 'pintado', 'caliente'], 1,
              'Un corte (circuito abierto) impide el paso de corriente.'),
        ],
      ),
      Lesson(
        id: 'ele2',
        emoji: '💡',
        title: 'LEDs y Resistencias',
        subtitle: 'Haciendo luz de forma segura',
        practiceType: PracticeType.electronics,
        challengeId: 'e2',
        cards: [
          LessonCard(_c, 'Conoce los componentes',
              'El LED emite luz, la resistencia controla cuánta corriente pasa, y el cable conecta todo. ¡Cada uno tiene su trabajo!'),
          LessonCard(_e, 'Proteger el LED',
              'Un LED solo puede aguantar poca corriente. Una resistencia lo protege para que no se queme.'),
          LessonCard(_f, '¿Sabías que…?',
              'LED significa "Diodo Emisor de Luz". ¡Gasta mucha menos energía que un foco normal!'),
        ],
        questions: [
          _q('eq5', '¿Qué componente emite luz?', ['la resistencia', 'el LED', 'el cable', 'la pila'], 1,
              'El LED se ilumina al pasar corriente.'),
          _q('eq6', '¿Para qué sirve una resistencia?', ['dar luz', 'limitar la corriente', 'guardar datos', 'hacer ruido'], 1,
              'Controla cuánta corriente pasa y protege componentes.'),
          _q('eq7', 'Si conectas un LED sin resistencia, puede…', ['quemarse', 'crecer', 'enfriarse', 'hablar'], 0,
              'Demasiada corriente quema el LED; la resistencia lo protege.'),
          _q('eq8', 'LED significa…', ['Diodo Emisor de Luz', 'Línea Eléctrica Directa', 'Luz En Día', 'nada'], 0,
              'Es un Diodo Emisor de Luz, muy eficiente.'),
        ],
      ),
      Lesson(
        id: 'ele3',
        emoji: '⚡',
        title: 'Energía y baterías',
        subtitle: 'De dónde sale la electricidad',
        cards: [
          LessonCard(_c, 'La batería',
              'La batería almacena energía química y la convierte en energía eléctrica para alimentar tu circuito.'),
          LessonCard(_t, 'Cuidado',
              'Conecta siempre los polos + y − correctamente. ¡Invertirlos puede dañar los componentes!'),
        ],
        questions: [
          _q('eq9', 'La batería convierte energía química en…', ['luz', 'eléctrica', 'sonido', 'agua'], 1,
              'Transforma energía química en energía eléctrica.'),
          _q('eq10', 'Los polos de una batería son…', ['+ y −', 'A y B', 'rojo y rojo', 'norte'], 0,
              'Tiene un polo positivo (+) y uno negativo (−).'),
          _q('eq11', 'Si inviertes los polos…', ['no pasa nada', 'puedes dañar componentes', 'va más rápido', 'da más luz'], 1,
              'La polaridad incorrecta puede dañar el circuito.'),
        ],
      ),
      Lesson(
        id: 'ele4',
        emoji: '🔘',
        title: 'Interruptores y motores',
        subtitle: 'Encender, apagar y mover',
        practiceType: PracticeType.electronics,
        challengeId: 'e3',
        cards: [
          LessonCard(_c, 'El interruptor',
              'El interruptor abre o cierra el circuito: cerrado deja pasar la corriente (encendido) y abierto la corta (apagado).'),
          LessonCard(_e, 'El motor',
              'El motor convierte la electricidad en movimiento. Con él haces girar una rueda o una hélice de tu robot.'),
          LessonCard(_t, 'Práctica',
              'Arma en el Simulador un circuito con pila, interruptor y motor, y enciéndelo para verlo girar.'),
        ],
        questions: [
          _q('eq12', 'El interruptor sirve para…', ['encender o apagar el circuito', 'dar luz', 'medir', 'sumar'], 0,
              'Abre o cierra el paso de la corriente.'),
          _q('eq13', 'El motor convierte electricidad en…', ['movimiento', 'luz', 'sonido', 'agua'], 0,
              'Transforma energía eléctrica en movimiento.'),
          _q('eq14', 'Para apagar un circuito, el interruptor queda…', ['abierto', 'cerrado', 'caliente', 'pintado'], 0,
              'Abierto = corta la corriente.'),
          _q('eq15', '¿Qué hace girar la rueda del robot?', ['el motor', 'la resistencia', 'el LED', 'el cable'], 0,
              'El motor produce el giro.'),
        ],
      ),
      Lesson(
        id: 'ele5',
        emoji: '🔔',
        title: 'Sensores y zumbadores',
        subtitle: 'Componentes que reaccionan',
        practiceType: PracticeType.electronics,
        challengeId: 'e1',
        cards: [
          LessonCard(_c, 'Componentes que reaccionan',
              'Un sensor de luz detecta si hay luz u oscuridad, y un zumbador (buzzer) hace sonido cuando pasa la corriente.'),
          LessonCard(_e, 'Lámpara automática',
              'Una lámpara de noche usa un sensor de luz: cuando oscurece, ¡enciende sola!'),
          LessonCard(_f, '¿Sabías que…?',
              'Los zumbadores avisan con un "beep" en alarmas, microondas y juguetes.'),
        ],
        questions: [
          _q('eq16', 'Un zumbador (buzzer) sirve para…', ['hacer sonido', 'dar luz fuerte', 'medir peso', 'girar'], 0,
              'Convierte electricidad en sonido.'),
          _q('eq17', 'Un sensor de luz detecta…', ['si hay luz u oscuridad', 'el sabor', 'el peso', 'la hora'], 0,
              'Mide la cantidad de luz.'),
          _q('eq18', 'Verdadero o Falso: un sensor le da información al circuito.', ['Verdadero', 'Falso'], 0,
              'Verdadero: los sensores aportan datos del entorno.'),
          _q('eq19', 'Una lámpara que enciende sola de noche usa un sensor de…', ['luz', 'sonido', 'sabor', 'color'], 0,
              'Detecta la oscuridad y enciende.'),
        ],
      ),
    ],
  ),

  // ==========================================================================
  // CIENCIA
  // ==========================================================================
  StemArea(
    id: 'ciencia',
    name: 'Ciencia',
    tagline: 'Descubre cómo funciona el mundo',
    icon: Icons.science_rounded,
    color: AppTheme.accentGreen,
    lessons: [
      Lesson(
        id: 'cie1',
        emoji: '🔬',
        title: 'El método científico',
        subtitle: 'Cómo investigan los científicos',
        cards: [
          LessonCard(_c, 'Los pasos',
              'Los científicos: 1) observan, 2) hacen una pregunta, 3) proponen una idea (hipótesis), 4) experimentan y 5) sacan conclusiones.'),
          LessonCard(_e, '¿Las plantas necesitan luz?',
              'Pones una planta al sol y otra en lo oscuro, esperas y observas cuál crece mejor. ¡Eso es experimentar!'),
        ],
        questions: [
          _q('cq1', '¿Cuál es el primer paso del método científico?', ['concluir', 'observar', 'dormir', 'comprar'], 1,
              'Todo empieza observando con atención.'),
          _q('cq2', 'Una hipótesis es…', ['una idea para probar', 'un error', 'una pila', 'un robot'], 0,
              'Es una posible respuesta que vas a comprobar.'),
          _q('cq3', 'Para comprobar una idea hacemos un…', ['dibujo', 'experimento', 'sueño', 'ruido'], 1,
              'El experimento pone a prueba la hipótesis.'),
          _q('cq4', 'Después de experimentar, sacamos…', ['conclusiones', 'fotos', 'pilas', 'nada'], 0,
              'Las conclusiones dicen qué aprendimos.'),
        ],
      ),
      Lesson(
        id: 'cie2',
        emoji: '🍎',
        title: 'Fuerzas y energía',
        subtitle: 'Lo que mueve al mundo',
        cards: [
          LessonCard(_c, 'La gravedad',
              'La gravedad es la fuerza que atrae los objetos hacia la Tierra. Por eso, lo que sueltas… ¡cae!'),
          LessonCard(_c, 'La fricción',
              'La fricción es una fuerza que frena el movimiento cuando dos superficies se rozan. Por eso un carrito se detiene.'),
          LessonCard(_f, '¿Sabías que…?',
              'En el espacio casi no hay gravedad ni fricción, por eso los astronautas flotan.'),
        ],
        questions: [
          _q('cq5', '¿Qué fuerza nos mantiene pegados al suelo?', ['gravedad', 'fricción', 'viento', 'imán'], 0,
              'La gravedad atrae los objetos hacia la Tierra.'),
          _q('cq6', 'La fricción hace que las cosas…', ['se aceleren', 'se frenen', 'vuelen', 'brillen'], 1,
              'La fricción frena el movimiento.'),
          _q('cq7', '¿Por qué flotan los astronautas?', ['casi no hay gravedad', 'son ligeros', 'usan alas', 'hace frío'], 0,
              'En el espacio la gravedad es muy débil.'),
          _q('cq8', 'Si sueltas una pelota, la gravedad la hace…', ['subir', 'caer', 'desaparecer', 'girar'], 1,
              'La gravedad la atrae hacia abajo.'),
        ],
      ),
      Lesson(
        id: 'cie3',
        emoji: '💧',
        title: 'Los estados de la materia',
        subtitle: 'Sólido, líquido y gas',
        cards: [
          LessonCard(_c, 'Tres estados',
              'La materia tiene 3 estados principales: sólido (firme), líquido (fluye) y gas (se expande). ¡El agua puede ser los tres!'),
          LessonCard(_e, 'El agua cambia',
              'Si calientas hielo se vuelve agua (líquido); si la hierves, se vuelve vapor (gas).'),
          LessonCard(_f, '¿Sabías que…?',
              'Pasar de líquido a gas se llama evaporación; de gas a líquido, condensación (como el rocío en la mañana).'),
        ],
        questions: [
          _q('cq9', 'Los 3 estados de la materia son sólido, líquido y…', ['gas', 'metal', 'vidrio', 'luz'], 0,
              'Sólido, líquido y gas.'),
          _q('cq10', 'El hielo es agua en estado…', ['sólido', 'líquido', 'gas', 'plasma'], 0,
              'El hielo es agua congelada (sólida).'),
          _q('cq11', 'Verdadero o Falso: el vapor es agua en estado gaseoso.', ['Verdadero', 'Falso'], 0,
              'Verdadero: el vapor es agua hecha gas.'),
          _q('cq12', 'Al calentar el hielo, se vuelve…', ['líquido', 'piedra', 'madera', 'metal'], 0,
              'El calor lo derrite a líquido.'),
          _q('cq13', 'Pasar de líquido a gas se llama…', ['evaporación', 'congelación', 'fusión', 'nada'], 0,
              'La evaporación convierte el líquido en gas.'),
        ],
      ),
      Lesson(
        id: 'cie4',
        emoji: '🪐',
        title: 'El sistema solar',
        subtitle: 'El Sol y los planetas',
        cards: [
          LessonCard(_c, 'Nuestro vecindario espacial',
              'El Sol es una estrella y a su alrededor giran 8 planetas. La Tierra es el tercero y el único con vida que conocemos.'),
          LessonCard(_e, 'Planetas curiosos',
              'Mercurio es el más cercano al Sol, Júpiter es el más grande y Saturno tiene anillos enormes.'),
          LessonCard(_f, '¿Sabías que…?',
              'La Luna no tiene luz propia: lo que vemos es la luz del Sol reflejada en ella.'),
        ],
        questions: [
          _q('cq14', '¿Cuántos planetas tiene el sistema solar?', ['8', '3', '100', '2'], 0,
              'Son 8 planetas girando alrededor del Sol.'),
          _q('cq15', 'La Tierra es el planeta número…', ['3', '1', '8', '5'], 0,
              'Es el tercero contando desde el Sol.'),
          _q('cq16', 'Verdadero o Falso: el Sol es un planeta.', ['Verdadero', 'Falso'], 1,
              'Falso: el Sol es una estrella.'),
          _q('cq17', 'El planeta con anillos famosos es…', ['Saturno', 'Marte', 'Tierra', 'Mercurio'], 0,
              'Saturno tiene anillos espectaculares.'),
          _q('cq18', 'La Luna brilla porque…', ['refleja la luz del Sol', 'tiene fuego', 'tiene focos', 'es una estrella'], 0,
              'Refleja la luz solar.'),
        ],
      ),
    ],
  ),

  // ==========================================================================
  // LÓGICA Y MATEMÁTICAS
  // ==========================================================================
  StemArea(
    id: 'logica',
    name: 'Lógica',
    tagline: 'Piensa y resuelve retos',
    icon: Icons.extension_rounded,
    color: AppTheme.accentOrange,
    lessons: [
      Lesson(
        id: 'log1',
        emoji: '🧩',
        title: 'Patrones y secuencias',
        subtitle: 'Encuentra lo que sigue',
        cards: [
          LessonCard(_c, '¿Qué es un patrón?',
              'Un patrón es algo que se repite con una regla. Si la descubres, puedes adivinar qué sigue.'),
          LessonCard(_e, 'Ejemplo',
              'En 2, 4, 6, 8… la regla es "sumar 2". Entonces lo siguiente es 10.'),
        ],
        questions: [
          _q('lq1', '¿Qué sigue? 2, 4, 6, 8, …', ['9', '10', '12', '7'], 1,
              'La regla suma 2: 8 + 2 = 10.'),
          _q('lq2', '¿Qué sigue? 🔺🟦🔺🟦🔺…', ['🔺', '🟦', '🟢', 'nada'], 1,
              'El patrón alterna triángulo y cuadrado: sigue 🟦.'),
          _q('lq3', '¿Qué sigue? 5, 10, 15, …', ['16', '20', '25', '18'], 1,
              'La regla suma 5: 15 + 5 = 20.'),
          _q('lq4', 'Un patrón es algo que…', ['se repite con una regla', 'es al azar', 'no existe', 'pesa mucho'], 0,
              'Sigue una regla que puedes descubrir.'),
        ],
      ),
      Lesson(
        id: 'log2',
        emoji: '🧠',
        title: 'Razonar y deducir',
        subtitle: 'Sacar conclusiones',
        cards: [
          LessonCard(_c, 'Deducción',
              'Deducir es llegar a una conclusión usando lo que sabes. Si conoces las reglas, puedes estar seguro de la respuesta.'),
          LessonCard(_t, 'Tip',
              'Para resolver un problema grande, divídelo en partes pequeñas. ¡Es más fácil!'),
        ],
        questions: [
          _q('lq5', 'Si "todos los robots tienen sensores" y "Robi es un robot", entonces Robi…', ['no tiene sensores', 'tiene sensores', 'es una pila', 'es humano'], 1,
              'Por deducción, Robi tiene sensores.'),
          _q('lq6', 'Dividir un problema en partes pequeñas se llama…', ['descomposición', 'destrucción', 'desorden', 'descanso'], 0,
              'La descomposición facilita resolver problemas.'),
          _q('lq7', '¿Cuál NO encaja: rueda, motor, batería, manzana?', ['rueda', 'motor', 'batería', 'manzana'], 3,
              'La manzana no es componente de robot.'),
          _q('lq8', 'Para resolver algo difícil conviene…', ['rendirse', 'dividirlo en pasos', 'adivinar', 'ignorarlo'], 1,
              'Paso a paso todo es más sencillo.'),
        ],
      ),
      Lesson(
        id: 'log3',
        emoji: '🪥',
        title: 'Algoritmos del día a día',
        subtitle: 'Pasos en orden para todo',
        cards: [
          LessonCard(_c, '¿Qué es un algoritmo?',
              'Un algoritmo es una serie de pasos en orden para lograr algo. ¡Hasta lavarte los dientes es un algoritmo!'),
          LessonCard(_e, 'Lavarse los dientes',
              '1) toma el cepillo, 2) pon pasta, 3) cepilla, 4) enjuaga. Cada paso en su orden.'),
          LessonCard(_t, 'Tip',
              'Si los pasos están en mal orden, el resultado falla. ¡El orden importa!'),
        ],
        questions: [
          _q('lq9', 'Un algoritmo es…', ['pasos en orden para lograr algo', 'un robot', 'una pila', 'un dibujo'], 0,
              'Una secuencia ordenada de pasos.'),
          _q('lq10', 'Verdadero o Falso: en un algoritmo el orden de los pasos importa.', ['Verdadero', 'Falso'], 0,
              'Verdadero: cambiar el orden cambia el resultado.'),
          _q('lq11', '¿Cuál es el primer paso para hacer un sándwich?', ['tomar el pan', 'comerlo', 'guardarlo', 'tirarlo'], 0,
              'Primero necesitas el pan.'),
          _q('lq12', 'Si haces los pasos en mal orden…', ['el resultado puede fallar', 'siempre sale bien', 'no importa', 'va más rápido'], 0,
              'El orden correcto es clave.'),
        ],
      ),
      Lesson(
        id: 'log4',
        emoji: '✅',
        title: 'Verdadero, falso y decisiones',
        subtitle: 'Cómo piensan las computadoras',
        cards: [
          LessonCard(_c, 'Verdadero o falso',
              'En lógica, algo es VERDADERO o FALSO. Las computadoras deciden comparando si una condición es verdadera.'),
          LessonCard(_e, '¿Me abrigo?',
              'SI "hace frío" es verdadero, ENTONCES me pongo abrigo. La computadora revisa si la condición se cumple.'),
          LessonCard(_f, '¿Sabías que…?',
              'Por dentro, las computadoras solo entienden 1 (verdadero) y 0 (falso): ¡es el código binario!'),
        ],
        questions: [
          _q('lq13', 'Verdadero o Falso: 5 es mayor que 3.', ['Verdadero', 'Falso'], 0,
              'Verdadero: 5 > 3.'),
          _q('lq14', 'Verdadero o Falso: un círculo tiene esquinas.', ['Verdadero', 'Falso'], 1,
              'Falso: el círculo no tiene esquinas.'),
          _q('lq15', 'Las computadoras por dentro usan…', ['1 y 0', 'letras A-Z', 'colores', 'dibujos'], 0,
              'El sistema binario: 1 y 0.'),
          _q('lq16', 'Una condición en lógica puede ser…', ['verdadera o falsa', 'solo verde', 'un robot', 'una pila'], 0,
              'Se evalúa como verdadera o falsa.'),
          _q('lq17', 'SI llueve ENTONCES llevo paraguas. Si NO llueve…', ['no llevo paraguas', 'llevo 5 paraguas', 'me mojo a propósito', 'nada tiene sentido'], 0,
              'La acción solo ocurre si la condición se cumple.'),
        ],
      ),
    ],
  ),
];
