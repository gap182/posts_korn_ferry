import 'package:flutter/material.dart';
import 'package:posts_korn_ferry/common/helpers/date_formatter.dart';
import 'package:provider/provider.dart';
import '../../state/posts_provider.dart';
import '../../../../common/models/post_model.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostsProvider>().refreshPosts(),
          ),
        ],
      ),
      body: const PostsList(),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.error!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          });
        }

        if (provider.posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !provider.isLoadingMore &&
                provider.hasMorePosts) {
              provider.loadMorePosts();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: provider.posts.length + (provider.hasMorePosts ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.posts.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final post = provider.posts[index];
              return PostCard(post: post, provider: provider);
            },
          ),
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final PostsProvider provider;

  const PostCard({super.key, required this.post, required this.provider});

  @override
  Widget build(BuildContext context) {
    final currentLike = provider.getPostLikeValue(post.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  postDateFormatted(post.createdAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(post.content),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => provider.incrementLike(post.id),
                  icon: Icon(
                    Icons.thumb_up,
                    color: currentLike == 1 ? Colors.purple : Colors.grey,
                  ),
                  label: const Text('Like'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        currentLike == 1 ? Colors.purple : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => provider.decrementLike(post.id),
                  icon: Icon(
                    Icons.thumb_down,
                    color: currentLike == -1 ? Colors.purple : Colors.grey,
                  ),
                  label: const Text('Dislike'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        currentLike == -1 ? Colors.purple : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
