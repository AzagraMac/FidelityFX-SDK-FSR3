#version 450

#ifndef FFX_THREAD_GROUP_WIDTH
#define FFX_THREAD_GROUP_WIDTH 256
#endif // #ifndef FFX_THREAD_GROUP_WIDTH
#ifndef FFX_THREAD_GROUP_HEIGHT
#define FFX_THREAD_GROUP_HEIGHT 1
#endif // FFX_THREAD_GROUP_HEIGHT
#ifndef FFX_THREAD_GROUP_DEPTH
#define FFX_THREAD_GROUP_DEPTH 1
#endif // #ifndef FFX_THREAD_GROUP_DEPTH
#ifndef FFX_NUM_THREADS
#define FFX_NUM_THREADS layout (local_size_x = FFX_THREAD_GROUP_WIDTH, local_size_y = FFX_THREAD_GROUP_HEIGHT, local_size_z = FFX_THREAD_GROUP_DEPTH) in;
#endif // #ifndef FFX_NUM_THREADS

FFX_NUM_THREADS
void main()
{
}
