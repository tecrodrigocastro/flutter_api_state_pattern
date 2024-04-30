import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rick_morty/app/store/character_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CharacterStore store = CharacterStore();

  @override
  void initState() {
    store.getCharacters();
    store.scroll.addListener(() {
      if (store.scroll.position.pixels ==
          store.scroll.position.maxScrollExtent) {
        store.page = store.page + 1;
        store.loadingMoreCharacters();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    store.dispose();
    store.scroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'Rick and\nMorty',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_rounded, color: Colors.green, size: 60),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            TextFormField(
              controller: store.searchEC,
              onChanged: (value) {
                store.searchCharacters(value);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade700,
                filled: true,
              ),
            ),
            const Gap(20),
            const Text(
              'Personagens',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: store,
                builder: (context, value, child) {
                  if (value is CharacterError) {
                    return Center(
                      child: Text(
                          'Erro ao carregar personagens: ${value.message}'),
                    );
                  }
                  if (value is CharacterLoaded) {
                    if (value.characters.isEmpty) {
                      return const Center(
                        child: Text('Nenhum personagem encontrado'),
                      );
                    }
                    return ListView.builder(
                      controller: store.scroll,
                      itemCount: value.characters.length,
                      itemBuilder: (context, index) {
                        final character = value.characters[index];
                        return ListTile(
                          leading: Image.network(character.image),
                          title: Text(character.name),
                          subtitle: Text(character.species),
                        );
                      },
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
