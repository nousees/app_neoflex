import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> historyData = [
    {
      'year': '2005',
      'event':
          'В феврале 2005 года группа менеджеров, имеющих многолетний опыт автоматизации банковской деятельности, создает компанию Neoflex, сфокусированную на оказании профессиональных услуг в сфере IT для финансовых организаций.',
    },
    {
      'year': '2006',
      'event':
          'Компания успешно расширяет деятельность по созданию SOA-ландшафтов и построению банковских хранилищ данных.',
    },
    {
      'year': '2007',
      'event':
          'Клиентами Neoflex становится ряд иностранных банков, выстраивающих IT-ландшафты своих дочерних структур с учетом специфики деятельности в России.',
    },
    {
      'year': '2008',
      'event':
          'Сформулирована продуктовая стратегия Neoflex. Начинается разработка первых собственных программных продуктов Neoflex FrontOffice и Neoflex Reporting.',
    },
    {
      'year': '2009',
      'event':
          'Несмотря на последствия кризиса 2008 года, компания продолжает расти и становится лидером по числу успешных SOA-проектов в России.',
    },
    {
      'year': '2010',
      'event': 'Neoflex создает практики «Управление рисками» и «Рынки капитала».',
    },
    {
      'year': '2011',
      'event':
          'Фокус на построении кредитных конвейеров на базе Neoflex FrontOffice.',
    },
    {
      'year': '2012',
      'event':
          'Neoflex уверенно растет, расширяет продуктовую линейку и увеличивает число международных партнеров.',
    },
    {
      'year': '2013',
      'event':
          'Компания фокусируется на построении комплексных бизнес-решений по автоматизации крупных блоков функциональности банка с использованием собственных программных продуктов и продуктов партнеров.',
    },
    {
      'year': '2014',
      'event':
          'Продолжается стабильное развитие компании по всем основным направлениям деятельности. Neoflex инвестирует в собственные программные продукты, совершенствует процессы, делает упор на повышение качества предлагаемых услуг и укрепление партнерских взаимоотношений с ключевыми клиентами.',
    },
    {
      'year': '2015',
      'event': 'Компания Neoflex отмечает 10-летний юбилей.',
    },
    {
      'year': '2016',
      'event':
          'Neoflex выполняет первые проекты с использованием технологий Big Data для создания решений класса IoT (интернет вещей), работы по анализу данных, а также проекты на основе микросервисной архитектуры для построения и интеграции фронт-офисных приложений. Компания расширяет свое присутствие на новых вертикальных рынках. Проектный опыт Neoflex становится востребованным на международном уровне.',
    },
    {
      'year': '2017',
      'event':
          'Neoflex обеспечивает цифровую трансформацию бизнеса организаций из более чем 15-и стран Европы, Африки и Юго-Восточной Азии.\n\nВ условиях растущей сложности современных ИТ-решений, процессов их создания и эксплуатации, компания развивает новые экспертизы и осваивает современные технологии. В фокусе Neoflex:\n- Создание высоконагруженных и высокодоступных информационных систем с применением микросервисной архитектуры приложений (Microservise Architecture), потоковых вычислений (Streaming processing), in-memory обработки данных и т.д.\n- Автоматизация получения отчетности, моделирование рисков, оптимизация затрат за счет применения средств обработки и анализа больших объемов данных, математического моделирования, искусственного интеллекта и машинного обучения.\n- Разработка эргономичных интерфейсов и бизнес-логики приложений, обеспечивающих создание новой ценности для привычных бизнес-процессов и продуктов за счет акцента на пользовательском опыте (UX – user experience). Активно применяются методологии Service Design, CJM (customer journey maps) и дизайн-мышления (Design Thinking).\n- Обеспечение высокой скорости развития бизнес-процессов заказчиков (Time-to-market) за счет применения практик DevOps, обеспечивающих непрерывный автоматический процесс разработки, внедрения и эксплуатации ПО.',
    },
    {
      'year': '2018',
      'event':
          'Neoflex сопровождает цифровую трансформацию бизнеса своих заказчиков, помогая им конкурировать в цифровых каналах, сокращать time-to-market и увеличивать эффективность процессов.\n\nСоздавая бизнес-приложения, которые позволяют заказчикам достигать лидерства в эпоху цифровой экономики, Neoflex применяет DevOps-подход и фокусируется на современных технологиях, таких как микросервисная архитектура приложений, streaming-processing, Big Data, Machine Learning, Artificial Intelligence.\n\nНовый импульс в развитии получили Neoflex Datagram и Neoflex MSA Platform – собственные решения и компоненты, обеспечивающие акселерацию разработки программного обеспечения.',
    },
    {
      'year': '2019',
      'event':
          'Neoflex фокусируется на заказной разработке высоконагруженных бизнес-приложений в микросервисной архитектуре и внедрении сложных ИТ-систем.\n\nКомпания расширяет международную географию присутствия. Состоялось открытие южноафриканского офиса в Йоханнесбурге, что обеспечило оперативное взаимодействие с заказчиками в регионе, а также Анголе и Нигерии.\n\nЗаключены партнерские соглашения с международными вендорами, такими как Lightbend, Camunda и WSO2.',
    },
    {
      'year': '2020',
      'event':
          'Neoflex показал значительный рост за счет микросервисной разработки и направления, связанного с большими данными: аналитические системы, системы потоковой обработки данных с применением технологий машинного обучения.\n\nВ 2020 году Neoflex реализовал ряд ключевых проектов по цифровой трансформации бизнеса крупнейших российских банков в части создания аналитических решений с использованием технологий Big Data, Fast Data и Machine Learning. Компания сфокусировалась на предоставлении клиентам глубокой отраслевой и технологической экспертизы, а также внедрении платформ и компонентов, на базе которых можно быстро разрабатывать и внедрять сложные решения.\n\nСоздан Центр развития компетенций для подготовки ИТ-кадров и усиления экспертизы в облачных технологиях, MLOps, Data Science, DevOps и Fast Data.\n\nОткрыт филиал и центр разработки Neoflex в городе Пензе с целью создания и развития команды экспертов.\n\nЗапущен в работу учебный центр на базе Воронежского государственного технического университета для обеспечения качественной подготовки будущих ИТ-специалистов.\n\nРасширена география проектов по цифровой трансформации бизнеса клиентов: впервые реализованы проекты в Китае и Узбекистане.\n\nПроизошли изменения в продуктовой линейке компании, касающиеся развития Open Source. Продукты Neoflex Reporting и Neoflex Datagram были включены в единый реестр российских программ для ЭВМ и баз данных.\n\nNeoflex стал первой российской компанией, получившей членство в международной Ассоциации Поставщиков Кредитной Информации (ACCIS). Это позволит компании обмениваться экспертизой с ключевыми мировыми игроками и обеспечит доступ к лучшим практикам в области цифровизации кредитных бюро. Компания заключила партнерство с РУССОФТ, направленное на развитие индустрии разработки программного обеспечения в России и содействие экспорту российского ПО.',
    },
    {
      'year': '2021',
      'event':
          'Команда Neoflex в 2021 году выросла с 785 до 1160 человек. Открыты новые офисы в Краснодаре и Самаре.\n\nФокус компании был направлен на автоматизацию цифровых каналов и бизнес-процессов для заказчиков, создании решений для анализа и принятия решений на основе AI и Big Data, также реализации проектов по автоматизации обязательной и налоговой отчетности, соответствию регуляторным требованиям и управлению рисками.\n\nДля развития экспертизы в области искусственного интеллекта была создана практика Data Science, которая дает возможность выполнять сложные проекты по разработке ML-моделей и использованию искусственного интеллекта в прикладных задачах. В связи с востребованностью у заказчиков решений на платформах iOS и Android был сформирован центр компетенций по разработке мобильных приложений на языках программирования Swift, Objective-C, Kotlin, Java.\n\nЗапущены новые направления по обучению студентов в «Учебном центре» Neoflex такие как, Data Analysis, DevOps, Java, Data Engineering, System Engineering, Scala, Тестирование, Аналитика, Front-end.\n\nВ рамках социальных инициатив компании стартовала программа по обучению компьютерной грамотности и программированию для детей в детских домах таких городов как Калязин, Воронеж, Саратов, Пенза. Проект нацелен на то, чтобы дать детям возможность получить современную профессию и новые возможности во взрослой жизни.',
    },
    {
      'year': '2022',
      'event':
          'В 2022 году фокус компании Neoflex был направлен на разработку и внедрение сложных бизнес-приложений с использованием передовых и современных методологий. Техническая и бизнес-экспертиза компании, дополненная собственными акселераторами, позволила решить бизнес-задачи по цифровой трансформации крупнейших компаний из таких отраслей как финансы, ритейл, страхование, инвестиции и девелопмент.\n\nКомпания реализовала ряд ключевых проектов в крупнейших российских банках и страховых компаниях в части внедрения продукта Neoflex Reporting для автоматизации обязательной отчетности ЦБ, а также платформы Neoflex MLOps Center – для управления жизненным циклом моделей машинного обучения.',
    },
    {
      'year': '2023',
      'event':
          'В 2023 году фокус компании был направлен на разработку и внедрение сложных бизнес-приложений с использованием передовых и современных методологий.\n\nТехнологическая экспертиза Neoflex была расширена и дополнена целым рядом центров компетенций и направлений:\n- Data Science для задач прогнозирования, видеоаналитики и LLM;\n- Управления жизненным циклом ML-моделей;\n- BI для систем отчетности;\n- iOS and Android мобильная разработка;\n- Yandex Cloud Development;\n- Нагрузочное тестирование.',
    },
    {
      'year': '2024',
      'event':
          'В 2024 году компания Neoflex продемонстрировала значительный рост по всем направлениям деятельности, укрепив свои позиции на рынке ИТ-решений и продолжив курс на инновации.\n\nОсновные результаты года:\n- Рост ключевых финансовых показателей составил более 25%;\n- Численность команды увеличилась на 200+ сотрудников, достигнув 1400+ специалистов.\n\nКомпания активно инвестировала в разработку новых решений и совершенствование существующих продуктов.\n\nСреди ключевых новинок:\n- Neoflex Reporting Risk — комплексное решение для расчета кредитных рисков и резервов в соответствии с МСФО и РСБУ;\n- Neoflex Foundation — микросервисная платформа для розничного кредитования;\n- Neoflex Reporting Studio — low-code инструмент для разработки веб-интерфейсов отчетности;\n- NEOMSA APIM — платформа для управления жизненным циклом API.',
    },
  ];

  void _previousYear() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _scrollToCurrentIndex();
      });
    }
  }

  void _nextYear() {
    if (_currentIndex < historyData.length - 1) {
      setState(() {
        _currentIndex++;
        _scrollToCurrentIndex();
      });
    }
  }

  void _scrollToCurrentIndex() {
    double offset = _currentIndex * 60.0 - (MediaQuery.of(context).size.width - 120) / 2;
    if (offset < 0) offset = 0;
    if (offset > _scrollController.position.maxScrollExtent) {
      offset = _scrollController.position.maxScrollExtent;
    }
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentIndex();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'История компании',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        color: _currentIndex > 0 ? Colors.orange : Colors.grey,
                        onPressed: _previousYear,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: historyData.length * 60.0,
                                color: Colors.red,
                              ),
                              Row(
                                children: List.generate(
                                  historyData.length,
                                  (index) => Container(
                                    width: 60,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentIndex = index;
                                          _scrollToCurrentIndex();
                                        });
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentIndex == index
                                                  ? Colors.yellow
                                                  : Colors.yellow.withOpacity(0.5),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            historyData[index]['year']!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black.withOpacity(0.5),
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        color: _currentIndex < historyData.length - 1
                            ? Colors.orange
                            : Colors.grey,
                        onPressed: _nextYear,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            historyData[_currentIndex]['year']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            historyData[_currentIndex]['event']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Вернуться'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 103, 3, 197),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}