# encoding=utf-8

import random
import copy


def insert_sort(arr, left_index, right_index):
    if not arr:
        return
    for i in xrange(left_index+1, right_index+1):  # 从left_index+1开始, 也就是从第二个开始
        for j in xrange(i, left_index, -1):
            if arr[j] < arr[j-1]:  # 注意保证j-1大于0
                # 通过不断的与前面已经排好序的元素比较并交换, 
                arr[j-1], arr[j] = arr[j], arr[j-1]
            else:
                break


def insert_sort_optimize(arr, left_index, right_index):
    if not arr:
        return
    for i in xrange(left_index+1, right_index+1):  # 从left_index+1开始, 也就是从第二个开始
        temp_i_val = arr[i]
        j = i
        while j >= left_index+1:
            if temp_i_val < arr[j-1]:  # 注意保证j-1大于0
                arr[j] = arr[j-1]  # 通过不断的与前面已经排好序的元素比较并直接赋值
                j -= 1
            else:
                break        
        arr[j] = temp_i_val  # 已经找到该插入的地方了, 直接赋值


def _merge(arr, left_index, mid_index, right_index):
    """
    归并的具体思路:  
        回到我们玩扑克牌的例子，假设桌上有两堆牌面朝上的牌，每堆都已**排序**，最小的牌在顶上。
        我们希望把这两堆牌合并成单一的排好序的输出堆，牌面朝下地放在桌上。
        我们的基本步骤包括在牌面朝上的两堆牌的顶上两张牌中选取较小的一张，将该牌从其堆中移开（该堆的顶上将
        显露一张新牌）并牌面朝下地将该牌放置到输出堆。
        重复这个步骤，直到一个输入堆为空，这时，我们只是拿起剩余的输入堆并牌面朝下地将该堆放置到输出堆。
    """
    # 注释掉下面这句是因为mid不一定等于(l+r)/2, 比如在`merge_sort_bottom_up()`就有可能
    # mid_index = left_index + (right_index - left_index) / 2
    temp_arr = []
    i = left_index
    j = mid_index + 1
    while i <= mid_index and j <= right_index:
        if arr[i] <= arr[j]:
            temp_arr.append(arr[i])
            i += 1
        else:
            temp_arr.append(arr[j])
            j += 1
    # 这一步是模拟: 直到一个输入堆为空，这时，我们只是拿起剩余的输入堆并牌面朝下地将该堆放置到输出堆。
    temp_arr.extend(arr[i:mid_index+1]) 
    temp_arr.extend(arr[j:right_index+1])  # 注意右边界是小于等于right_index的
    # 把归并好的数组数据放到原数组left_index到right_index的位置上去
    for m in xrange(0, right_index-left_index+1):
        arr[left_index+m] = temp_arr[m]
        
        
def merge_sort(arr, left_index, right_index):
    # 当 `merge_sort()` 递归到left_index等于right_index的时候, 
    # 说明left_index, right_index已经相邻了,
    # 说明已经分解到底了, 左右都只剩下一个元素了, 所以此时应该return然后执行 `_merge()` 了
    if not arr or left_index >= right_index:
        return
    # 注意这里不能直接 `mid_index=(left_index+right_index)/2`,
    # 防止当left_index和right_index很大的时候他们之和溢出
    mid_index = left_index + (right_index - left_index) / 2
    merge_sort(arr, left_index, mid_index)
    merge_sort(arr, mid_index+1, right_index)
    _merge(arr, left_index, mid_index, right_index)
    

def merge_sort_optimize(arr, left_index, right_index):
    # 当 `merge_sort()` 递归到left_index等于right_index的时候, 
    # 说明left_index, right_index已经相邻了,
    # 说明已经分解到底了, 左右都只剩下一个元素了, 所以此时应该return然后执行 `_merge()` 了
    if not arr or left_index >= right_index:
        return

    # 优化1:
    #   数据量较小则使用插入排序
    if (right_index - left_index) < 15:
        insert_sort_optimize(arr, left_index, right_index)
        return

    # 注意这里不能直接 `mid_index=(left_index+right_index)/2`,
    # 防止当left_index和right_index很大的时候他们之和溢出
    mid_index = left_index + (right_index - left_index) / 2
    merge_sort(arr, left_index, mid_index)
    merge_sort(arr, mid_index+1, right_index)

    # 优化2: 
    #   因为此时arr[mid_index]左边的数组里最大的, 而arr[mid_index+1]是右边最小的,
    #   如果arr[mid_index] <= arr[mid_index+1]则说明这一轮递归的arr的left到right已经是从小到大有序的了
    #   所以只在对于arr[mid_index] > arr[mid_index+1]的情况,进行merge, 
    #   对于近乎有序的数组非常有效,但是对于一般情况,有一定的性能损失(因为多了这行代码判断大小)
    if arr[mid_index] > arr[mid_index+1]:
        _merge(arr, left_index, mid_index, right_index)


def merge_sort_bottom_up(arr, left_index, right_index):
    if not arr or left_index >= right_index:
        return
    arr_len = right_index - left_index + 1
    size = 1
    # 注意这里不是 `while size <= arr_len/2`,
    # 比如arr_len=12, size为4的话, 只能把[0, 7]和[8, 11]的两个子数组归并成有序
    # 那只有size为8, 这样2倍size才能把arr全部归并
    # 但size=8的话, 大于arr_len/2了, 所以应该`while size < arr_len`
    while size < arr_len:
        cur_left_index = left_index
        while cur_left_index <= right_index-size:
            cur_mid_index = cur_left_index + size -1
            possible_right_index = cur_left_index + 2*size -1
            # possible_right_index有可能已经大于right_index了, 所以要min一下
            cur_right_index = min(possible_right_index, right_index)
            # 归并从i位置开始的两倍size的一组数据
            _merge(arr, cur_left_index, cur_mid_index, cur_right_index)
            cur_left_index += size * 2  # 每次归并完一组数据就i移动size的两倍
        # print "size: %d" % size
        # print arr
        size *= 2  # size从1开始每次增加两倍
        

def merge_sort_bottom_up_optimize(arr, left_index, right_index):
    if not arr or left_index >= right_index:
        return

    # 优化1:
    #   先以size为16为一组数据来逐个对每组插入排序一遍
    size = 16
    cur_left_index = left_index
    while cur_left_index < right_index:
        possible_right_index = cur_left_index + 2*size -1
         # possible_right_index有可能已经大于right_index了, 所以要min一下
        cur_right_index = min(possible_right_index, right_index)
        insert_sort(arr, cur_left_index, cur_right_index)
        cur_left_index += size  # 右移到下一个size大小开头位置
    
    arr_len = right_index - left_index + 1
    # size = 1
    
    # 注意这里不是 `while size <= arr_len/2`,
    # 比如arr_len=12, size为4的话, 只能把[0, 7]和[8, 11]的两个子数组归并成有序
    # 那只有size为8, 这样2倍size才能把arr全部归并
    # 但size=8的话, 大于arr_len/2了, 所以应该`while size < arr_len`
    while size < arr_len:
        cur_left_index = left_index
        while cur_left_index <= right_index-size:
            cur_mid_index = cur_left_index + size -1
            possible_right_index = cur_left_index + 2*size -1
            # possible_right_index有可能已经大于right_index了, 所以要min一下
            cur_right_index = min(possible_right_index, right_index)
            # 归并从i位置开始的两倍size的一组数据
            # 优化2: 
            #   因为此时arr[mid_index]左边的数组里最大的, 而arr[mid_index+1]是右边最小的,
            #   如果arr[mid_index] <= arr[mid_index+1]则说明这一轮递归的arr的left到right已经是从小到大有序的了
            #   所以只在对于arr[mid_index] > arr[mid_index+1]的情况,进行merge, 
            #   对于近乎有序的数组非常有效,但是对于一般情况,有一定的性能损失(因为多了这行代码判断大小)
            if arr[cur_mid_index] > arr[cur_mid_index+1]:
                _merge(arr, cur_left_index, cur_mid_index, cur_right_index)
            cur_left_index += size * 2  # 每次归并完一组数据就i移动size的两倍
        # print "size: %d" % size
        # print arr
        size *= 2  # size从1开始每次增加两倍
        

def _partition(arr, left_index, right_index):
    # 选一个元素作为枢轴量,
    # 为了模拟上面这个动画演示, 这里我们选取最左边的元素
    pivot_index = left_index
    pivot = arr[pivot_index]
    # partition_index 在还没开始遍历之前时应该指向待遍历元素的最左边的那个元素的前一个位置
    # 在这里这种写法就是 `left_index`
    # 这才符合partition_index的定义:
    #       partition_indexy指向小于pivot的那些元素的最后一个元素,
    #       即 less_than_pivots_last_elem_index
    # 因为还没找到比pivot小的元素之前, 
    # partition_index是不应该指向任何待遍历的元素的
    partition_index = less_than_pivots_last_elem_index = left_index

    i = left_index + 1  # 因为pivot_index取left_index了, 则我们从left_index+1开始遍历
    while i <= right_index:
        if arr[i] < pivot:
            arr[i], arr[partition_index+1] = arr[partition_index+1], arr[i]
            partition_index += 1
        i += 1
    arr[pivot_index], arr[partition_index] = arr[partition_index], arr[pivot_index]
    return partition_index


def quick_sort(arr, left_index, right_index):
    # 如果left等于right则说明已经partition到只有一个元素了, 可以直接return了
    if not arr or left_index >= right_index:
        return
    partition_index = _partition(arr, left_index, right_index)
    # 把partition_index左边的数据再递归快排一遍
    quick_sort(arr, left_index, partition_index-1)
    quick_sort(arr, partition_index+1, right_index)


def _partition_optimize(arr, left_index, right_index):
    # 选一个元素作为枢轴量,
    # 为了模拟上面这个动画演示, 这里我们选取最左边的元素
    pivot_index = left_index

    # 优化1:
    #   随机选一个元素和最左边的交换,
    #   配合下方的`pivot = arr[left_index]`就达到了随机选一个元素当pivot的效果
    rand_index = random.randint(left_index, right_index)
    arr[pivot_index], arr[rand_index] = arr[rand_index], arr[pivot_index]

    pivot = arr[pivot_index]
    # partition_index 在还没开始遍历之前时应该指向待遍历元素的最左边的那个元素的前一个位置
    # 在这里这种写法就是 `left_index`
    # 这才符合partition_index的定义:
    #       partition_indexy指向小于pivot的那些元素的最后一个元素,
    #       即 less_than_pivots_last_elem_index
    # 因为还没找到比pivot小的元素之前, 
    # partition_index是不应该指向任何待遍历的元素的
    partition_index = less_than_pivots_last_elem_index = left_index

    i = left_index + 1  # 因为pivot_index取left_index了, 则我们从left_index+1开始遍历
    while i <= right_index:
        if arr[i] < pivot:
            arr[i], arr[partition_index+1] = arr[partition_index+1], arr[i]
            partition_index += 1
        i += 1
    arr[pivot_index], arr[partition_index] = arr[partition_index], arr[pivot_index]
    return partition_index


def quick_sort_optimize(arr, left_index, right_index):
    # 如果left等于right则说明已经partition到只有一个元素了, 可以直接return了
    if not arr or left_index >= right_index:
        return
    # 优化2:
    #   小数组用插排
    if (right_index - left_index) <= 15:
        insert_sort(arr, left_index, right_index)
        return
    partition_index = _partition(arr, left_index, right_index)
    # 把partition_index左边的数据再递归快排一遍
    quick_sort(arr, left_index, partition_index-1)
    quick_sort(arr, partition_index+1, right_index)
    

def quick_sort_3_ways(arr, left_index, right_index):
    # 如果left等于right则说明已经partition到只有一个元素了, 可以直接return了
    if not arr or left_index >= right_index:
        return
    if (right_index - left_index) <= 15:
        insert_sort(arr, left_index, right_index)
        return

    # 选一个元素作为枢轴量,
    # 为了模拟上面这个动画演示, 这里我们选取最左边的元素
    pivot_index = left_index
    # 随机选一个元素和最左边的交换,
    # 配合下方的`pivot = arr[left_index]`就达到了随机选一个元素当pivot的效果
    rand_index = random.randint(left_index, right_index)
    arr[pivot_index], arr[rand_index] = arr[rand_index], arr[pivot_index]
    
    pivot = arr[pivot_index]
    # lt_index 指向小于pivot的那些元素的最右边的一个元素,
    # lt_index 即 less_than_pivots_last_elem_index
    # 因为还没找到比pivot小的元素之前, 
    # lt_index 是不应该指向任何待遍历的元素的, 
    # gt_index 同理, gt_index指向大于pivot的那些元素的最左边的一个元素,
    lt_index = less_than_pivots_last_elem_index = left_index
    gt_index = right_index + 1

    i = left_index + 1  # 因为pivot_index取left_index了, 则我们从left_index+1开始遍历
    while i < gt_index:
        if arr[i] < pivot:
            arr[i], arr[lt_index+1] = arr[lt_index+1], arr[i]
            lt_index += 1
            i += 1
        elif arr[i] > pivot:
            arr[i], arr[gt_index-1] = arr[gt_index-1], arr[i]
            gt_index -= 1
        else:
            i += 1
    arr[pivot_index], arr[lt_index] = arr[lt_index], arr[pivot_index]

    quick_sort_3_ways(arr, left_index, lt_index)
    quick_sort_3_ways(arr, gt_index, right_index)
    

# 递归版, 对 pending_heapify_index 元素执行堆化
def _max_heapify_recursive(arr, pending_heapify_index, left_index, right_index):
    if pending_heapify_index >= right_index:  # 当满足此条件, 应该结束`_max_heapify_recursive`递归了
        return
    left_child_index = 2 * (pending_heapify_index-left_index) + 1
    right_child_index = left_child_index + 1

    # 选出 pending_heapify_index 的左右孩子中最大的元素,
    # 并与 pending_heapify_index 元素交换
    cur_max_index = pending_heapify_index
    if left_child_index <= right_index and arr[cur_max_index] < arr[left_child_index]:
        cur_max_index = left_child_index
    if right_child_index <= right_index and arr[cur_max_index] < arr[right_child_index]:
        cur_max_index = right_child_index

    # 若当前已经是最大元素了, 则停止递归, 如果不是则执行交换与继续递归
    if cur_max_index != pending_heapify_index:
        arr[pending_heapify_index], arr[cur_max_index] = arr[cur_max_index], arr[pending_heapify_index]
        _max_heapify_recursive(arr, cur_max_index, left_index, right_index)  # 继续 堆化 cur_max_index 的子元素


# 对 迭代版, pending_heapify_index 元素执行堆化
def _max_heapify_iterative(arr, pending_heapify_index, left_index, right_index):
    left_child_index = 2 * (pending_heapify_index-left_index) + 1
    while left_child_index <= right_index:
        right_child_index = left_child_index + 1
        # 选出 pending_heapify_index 的左右孩子中最大的元素,
        # 并与 pending_heapify_index 元素交换
        cur_max_index = pending_heapify_index
        if left_child_index <= right_index and arr[cur_max_index] < arr[left_child_index]:
            cur_max_index = left_child_index
        if right_child_index <= right_index and arr[cur_max_index] < arr[right_child_index]:
            cur_max_index = right_child_index

        # 若当前已经是最大元素了, 则直接break, 如果不是则执行交换与继续新一轮的堆化循环
        if cur_max_index != pending_heapify_index:
            arr[pending_heapify_index], arr[cur_max_index] = arr[cur_max_index], arr[pending_heapify_index]
            pending_heapify_index = cur_max_index
            left_child_index = 2 * (pending_heapify_index-left_index) + 1
        else:
            break


def _build_max_heap(arr, left_index, right_index):
    # 建堆, 从最后一个非叶结点开始, 自底向上堆化就建好了一个最大堆
    root_index = left_index
    arr_len = right_index - left_index + 1
    last_none_leaf_index = root_index + (arr_len/2 - 1)

    i = last_none_leaf_index
    while i >= root_index:
        _max_heapify_recursive(arr, i, left_index, right_index)
        i -= 1


def heap_sort(arr, left_index , right_index):
    if not arr or left_index >= right_index or right_index <= 0:
        return
    _build_max_heap(arr, left_index, right_index)
    # 把数组中的第一个元素(即根节点)也就是当前堆的最大元素逐个和数组后面的元素交换
    # 交换后根节点已经违背最大堆性质了, 但其他的元素还是符合最大堆性质的
    # 所以然后要对根节点做一次堆化操作
    cur_right_index = right_index
    root_index = left_index
    while cur_right_index >= root_index:
        arr[root_index], arr[cur_right_index] = arr[cur_right_index], arr[root_index]
        cur_right_index -= 1
        _max_heapify_recursive(arr, root_index, left_index, cur_right_index)


class BinaryTreeNode(object):
    
    def __init__(self, val):
        self.left = None
        self.right = None
        self.val = val


def binary_tree_preorder_traversal(root):
    _result_arr = []
    if not root:
        return _result_arr
    _temp_stack = []
    _temp_stack.append(("go", root))
    while _temp_stack:
        _cmd, _cur_node = _temp_stack.pop(-1)
        if _cmd == "print":
            _result_arr.append(_cur_node.val)
            continue
        if _cur_node.right:
            _temp_stack.append(("go", _cur_node.right))
        if _cur_node.left:
            _temp_stack.append(("go", _cur_node.left))
        _temp_stack.append(("print", _cur_node))
    return _result_arr


def binary_tree_inorder_traversal(root):
    _result_arr = []
    if not root:
        return _result_arr
    _temp_stack = []
    _temp_stack.append(("go", root))
    while _temp_stack:
        _cmd, _cur_node = _temp_stack.pop(-1)
        if _cmd == "print":
            _result_arr.append(_cur_node.val)
            continue
        if _cur_node.right:
            _temp_stack.append(("go", _cur_node.right))
        _temp_stack.append(("print", _cur_node))
        if _cur_node.left:
            _temp_stack.append(("go", _cur_node.left))
    return _result_arr


def binary_tree_postorder_traversal(root):
    _result_arr = []
    if not root:
        return _result_arr
    _temp_stack = []
    _temp_stack.append(("go", root))
    while _temp_stack:
        _cmd, _cur_node = _temp_stack.pop(-1)
        if _cmd == "print":
            _result_arr.append(_cur_node.val)
            continue
        _temp_stack.append(("print", _cur_node))
        if _cur_node.right:
            _temp_stack.append(("go", _cur_node.right))
        if _cur_node.left:
            _temp_stack.append(("go", _cur_node.left))
    return _result_arr


def binary_tree_levelorder_traversal(root):
    _result_arr = []
    if not root:
        return _result_arr
    _temp_queue = []
    _temp_queue.append(root)
    while _temp_queue:
        _cur_node = _temp_queue.pop(0)
        _result_arr.append(_cur_node.val)
        if _cur_node.left:
            _temp_queue.append(_cur_node.left)
        if _cur_node.right:
            _temp_queue.append(_cur_node.right)
    return _result_arr


def binary_tree_swap_recursive(root):
    if not root:
        return
    root.left, root.right = root.right, root.left
    binary_tree_swap_recursive(root.left)
    binary_tree_swap_recursive(root.right)


def binary_tree_swap_iterative(root):
    if not root:
        return
    _temp_stack = []
    _temp_stack.append(("go", root))
    while _temp_stack:
        _cmd, _cur_node = _temp_stack.pop(-1)
        if _cmd == "print":
            # 参考前序遍历的迭代写法, 就只有这里改成了swap操作
            _cur_node.left, _cur_node.right = _cur_node.right, _cur_node.left
            continue
        if _cur_node.right:
            _temp_stack.append(("go", _cur_node.right))
        _temp_stack.append(("print", _cur_node))
        if _cur_node.left:
            _temp_stack.append(("go", _cur_node.left))


class LinkList(object):

    def __init__(self, val):
        self.next = None
        self.val = val


def linklist_reverse(head):
    if not head:
        return
    _pre = None
    _cur = head
    _temp_next = head.next
    while _cur:
        #先用_temp_next保存_cur的下一个节点的信息，
        #保证单链表不会因为失去_cur节点的next而就此断裂
        _temp_next = _cur.next
        #保存完_temp_next，就可以让_cur的next指向_pre了
        _cur.next = _pre
        #让_pre，_cur依次向后移动一个节点，继续下一次的指针反转
        _pre = _cur
        _cur = _temp_next
    return _pre


class GraphBase(object):
    # 图的基类

    def __init__(self, point_count, is_directed):
        # 因为稀疏图一般用邻接表来保存图的顶点数据,
        # 而稠密图一般用邻接矩阵来表示, 所以他们的保存邻接点容器是不同的,
        # 留给具体子类来指定, 此处用 `self.adjacency_container = None`表示即可
        self.adjacency_container = None
        self.is_directed = is_directed  # 是否为有向图
        self.connected_components_count = 0  # 连通分量个数
    
    def graph_dfs(self):
        """
        图的深度优先遍历（DFS）, 深度优先遍历尽可能优先往深层次进行搜索；
        1. 首先访问出发点v，并将其标记为已访问过；
        2. 然后依次从v出发搜索v的每个邻接点w。若w未曾访问过，则以w为新的出发点继续进行深度优先遍历，直至图中所有和源点v有路径相通的顶点均已被访问为止。
        3. 若此时图中仍有未访问的顶点，则另选一个尚未访问的顶点为新的源点重复上述过程，直至图中所有的顶点均已被访问为止。
        """
        visited_arr = []
        for _cur_point_index in xrange(0, len(self.adjacency_container)):
            if _cur_point_index not in visited_arr:
                self._dfs_by_point(_cur_point_index, visited_arr)
                # 运行到此处, 说明已经把所有和_cur_point_index 相连接的点都遍历完了,
                # A-B-C 也算作 A和C相连接的,
                # 其他的点肯定在另一个连接分量中
                self.connected_components_count += 1
        return visited_arr

    def _dfs_by_point(self, cur_point_index, visited_arr):
        visited_arr.append(cur_point_index)
        for _next_point_index in self._iter_adjacent_points(cur_point_index):
            if _next_point_index not in visited_arr:
                self._dfs_by_point(_next_point_index, visited_arr)

    def graph_bfs(self):
        """
        图的广度优先遍历, 也可以称为图的层序遍历, 广度优先遍历按层次优先搜索最近的结点，一层一层往外搜索:
        1. 首先访问出发点v，接着依次访问v的所有邻接点w1、w2......wt，
        2. 然后依次访问w1、w2......wt邻接的所有未曾访问过的顶点。
        3. 以此类推，直至图中所有和源点v有路径相通的顶点都已访问到为止。此时从v开始的搜索过程结束。
        4. 若此时图中仍有未访问的顶点，则另选一个尚未访问的顶点为新的源点重复上述过程，直至图中所有的顶点均已被访问为止。
        """
        result_arr = []
        visited_set = set()  # 用来记录某个顶点是否已经访问过
        _temp_queue = []
        for _cur_point_index in xrange(0, len(self.adjacency_container)):
            if _cur_point_index not in visited_set:
                _temp_queue.append(_cur_point_index)
                visited_set.add(_cur_point_index)
            while _temp_queue:
                _pt = _temp_queue.pop(0)
                result_arr.append(_pt)
                for _next_pt_index in self._iter_adjacent_points(_pt):
                    if _next_pt_index not in visited_set:
                        _temp_queue.append(_next_pt_index)
                        visited_set.add(_next_pt_index)
        return result_arr


    def _iter_adjacent_points(self, cur_point_index):
        """
        因为稀疏图一般用邻接表来保存图的顶点数据,
        而稠密图一般用邻接矩阵来表示,
        所以他们的遍历邻接点的方式是不同的, 留给具体的子类来实现.
        """
        raise NotImplementedError


class SparseGraph(GraphBase):
    # 稀疏图

    def __init__(self, point_count, is_directed):
        super(SparseGraph, self).__init__(point_count, is_directed)
        self.adjacency_container = [ [] for _ in xrange(point_count) ]  # 邻接表

    def set_adjacency_list(self, adjacency_list):
        self.adjacency_container = adjacency_list

    def _iter_adjacent_points(self, cur_point_index):
        for _adjacent_point_index in self.adjacency_container[cur_point_index]:
            yield _adjacent_point_index


class DenseGraph(GraphBase):
    # 稠密图

    def __init__(self, point_count, is_directed):
        super(DenseGraph, self).__init__(point_count, is_directed)
        self.adjacency_container = [
            [ 0 for _ in xrange(point_count)] for _ in xrange(point_count) 
        ]  # 邻接矩阵

    def set_adjacency_matrix(self, adjacency_matrix):
        self.adjacency_container = adjacency_matrix

    def _iter_adjacent_points(self, cur_point_index):
        for _adjacent_point_index, _is_point_adjacent in enumerate(self.adjacency_container[cur_point_index]):
            if not _is_point_adjacent:
                continue
            yield _adjacent_point_index


# 首先要明确此递归函数的定义: 查看root是否为叶子结点并且root的val是否等于sum_num,
# 然后才开始写代码
def has_path_sum(root, sum_num):
	if not root:
		return False
    # 判断是否为叶子
	if not root.left and not root.left and root.val == sum_num:
		return True
    # 通过递归, 继续查看左右孩子节点是否有 sum_num-root.val
	if has_path_sum(root.left, sum_num-root.val):
		return True
	return has_path_sum(root.right, sum_num-root.val)


def binary_tree_paths(root):
    result_arr = []
    if not root:
        return result_arr
    if not root.left and not root.right:
        result_arr.append(str(root.val))
        return result_arr
    # 获取左孩子的路径
    left_bt_path_arr = binary_tree_paths(root.left)
    for _path in left_bt_path_arr:
        result_arr.append(str(root.val) + "->" + _path)
    # 获取右孩子的路径
    right_bt_path_arr = binary_tree_paths(root.right)
    for _path in right_bt_path_arr:
        result_arr.append(str(root.val) + "->" + _path)
    return result_arr


def _get_path_sum_include_node(node, sum_num):
    if not node:
        return 0
    _path_cnt = 0
    if node.val == sum_num:  # node本身值等于sum_num也算一条路径
        _path_cnt += 1
    _path_cnt += _get_path_sum_include_node(node.left, sum_num-node.val)
    _path_cnt += _get_path_sum_include_node(node.right, sum_num-node.val)
    return _path_cnt


def path_sum_3(root, sum_num):
    if not root:
        return 0
    path_cnt = 0
    # 先求包括node本身的情况, 此时这轮递归所说的node是代码中的root
    # 这种情况可以用类似于 path_sum问题 的 `has_path_sum`来实现
    path_cnt += _get_path_sum_include_node(root, sum_num)
    # 再求不包括node本身的情况, 
    # 直接计算左右孩子往下的路径中和为sum_num(注意不是sum_num-root.val)的路径数量
    path_cnt += path_sum_3(root.left, sum_num)
    path_cnt += path_sum_3(root.right, sum_num)
    return path_cnt
        


if __name__ == "__main__":
        
    sort_algo_func_list = [
        insert_sort,
        merge_sort, merge_sort_bottom_up, merge_sort_bottom_up_optimize, 
        quick_sort, quick_sort_optimize, quick_sort_3_ways,
        heap_sort,
    ]
    test_arr_list = [
        [4, 3, 5, 1, 88, 0, -7, 2, 66, -58],
        [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
        [4, 3, 5, 1, 88, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, -7, 2, 66, -58],
        [4, 3, 5, 1, 88, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, -7, 2, 66, -58],
        [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, -7, 2, 66, -58, 4, 3, 5, 1, 88],
        [0, -7, 2, 66, -58, 4, 3, 5, 1, 884, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
        [-3, -7, 1, 2, 3, 4, 5, 6, 7, 8, 21, 42, 87, 99, 66, 32, 91, 19, 28],
        [8, 7, 6, 5, 4, 3, 2, 1, 0, -1, 21, 42, 87, 99, 66, 32, 91, 19, 28],
    ]
    for _sort_algo in sort_algo_func_list:
        print _sort_algo.__name__
        is_test_pass = True
        for _test_arr in test_arr_list:
            _copy_test_arr = copy.deepcopy(_test_arr)
            _sort_algo(_copy_test_arr, 0, len(_copy_test_arr)-1)
            # print _copy_test_arr
            pre_elem = _copy_test_arr[0]
            for _elem in _copy_test_arr:
                if _elem < pre_elem:
                    print  "is not ordered: " + str(_test_arr)
                    is_test_pass = False
                    break
        print "-------------test " + \
            ("pass" if is_test_pass else "not pass") + \
            "---------------"

    print "\n"

    _bt_a = BinaryTreeNode('a')
    _bt_b = BinaryTreeNode('b')
    _bt_c = BinaryTreeNode('c')
    _bt_d = BinaryTreeNode('d')
    _bt_e = BinaryTreeNode('e')
    _bt_f = BinaryTreeNode('f')
    _bt_g = BinaryTreeNode('g')
    _bt_a.left = _bt_b
    _bt_b.left = _bt_c
    _bt_b.right = _bt_d
    _bt_d.left = _bt_e
    _bt_d.right = _bt_f
    _bt_e.right = _bt_g

    bt_traversal_func_list = {
        binary_tree_preorder_traversal: ['a', 'b', 'c', 'd', 'e', 'g', 'f'],
        binary_tree_inorder_traversal: ['c', 'b', 'e', 'g', 'd', 'f', 'a'],
        binary_tree_postorder_traversal: ['c', 'g', 'e', 'f', 'd', 'b', 'a'],
        binary_tree_levelorder_traversal: ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    }
    for _bt_traversal_func, _pass_result_arr in bt_traversal_func_list.iteritems():
        print _bt_traversal_func.__name__
        print "------------test " + \
            ("pass" if _bt_traversal_func(_bt_a) == _pass_result_arr else "not pass") + \
            "---------------"

    print ""

    _copy_bt_a = copy.deepcopy(_bt_a)
    binary_tree_swap_recursive(_copy_bt_a)
    print "after binary_tree_swap_recursive, levelorder traversal:"
    print binary_tree_levelorder_traversal(_copy_bt_a)

    _copy_bt_a = copy.deepcopy(_bt_a)
    binary_tree_swap_iterative(_copy_bt_a)
    print "after binary_tree_swap_iterative, levelorder traversal:"
    print binary_tree_levelorder_traversal(_copy_bt_a)

    print "\n"
    
    _ll_a = LinkList('a')
    _ll_b = LinkList('b')
    _ll_c = LinkList('c')
    _ll_d = LinkList('d')
    _ll_e = LinkList('e')
    _ll_a.next = _ll_b
    _ll_a.next.next = _ll_c
    _ll_a.next.next.next = _ll_d
    _ll_a.next.next.next.next = _ll_e

    print "after linklist_reverse: "
    new_head = linklist_reverse(_ll_a)
    i = new_head
    while i:
        print i.val, "->",
        i = i.next

    print "\n"

    temp_adjacency_list = [
        [1, 2, 5, 6],
        [0],
        [0],
        [4, 5],
        [3, 5, 6],
        [0, 3, 4],
        [0, 4],
    ]
    test_sparse_graph = SparseGraph(point_count=len(temp_adjacency_list), is_directed=False)
    test_sparse_graph.set_adjacency_list(temp_adjacency_list)
    print "test_sparse_graph graph dfs:"
    print test_sparse_graph.graph_dfs()
    print "test_sparse_graph graph bfs:"
    print test_sparse_graph.graph_bfs()

    # 这个邻接矩阵表示的和上面那个邻接表 temp_adjacency_list 是同一个图
    temp_adjacency_matrix = [
        [0, 1, 1, 0, 0, 1, 1],
        [1, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 0],
        [0, 0, 0, 1, 0, 1, 1],
        [1, 0, 0, 1, 1, 0, 0],
        [1, 0, 0, 0, 1, 0, 0],
    ]
    test_dense_graph = DenseGraph(point_count=len(temp_adjacency_matrix), is_directed=False)
    test_dense_graph.set_adjacency_matrix(temp_adjacency_matrix)
    print "test_dense_graph graph dfs:"
    print test_dense_graph.graph_dfs()
    print "test_dense_graph graph bfs:"
    print test_dense_graph.graph_bfs()

    print "\n"

    bt_5 = BinaryTreeNode(5)
    bt_4a = BinaryTreeNode(4)
    bt_8 = BinaryTreeNode(8)
    bt_11 = BinaryTreeNode(11)
    bt_13 = BinaryTreeNode(13)
    bt_4b = BinaryTreeNode(4)
    bt_7 = BinaryTreeNode(7)
    bt_2 = BinaryTreeNode(2)
    bt_1 = BinaryTreeNode(1)

    bt_5.left = bt_4a
    bt_5.right = bt_8
    bt_4a.left = bt_11
    bt_11.left = bt_7
    bt_11.right = bt_2
    bt_8.left = bt_13
    bt_8.right = bt_4b
    bt_13.right = bt_1

    print "path_sum:"
    print "5: " + str(has_path_sum(bt_5, sum_num=5))
    print "0: " + str(has_path_sum(bt_5, sum_num=0))
    print "22: " + str(has_path_sum(bt_5, sum_num=22))
    print "13: " + str(has_path_sum(bt_5, sum_num=13))
    print "17: " + str(has_path_sum(bt_5, sum_num=17))
    print "27: " + str(has_path_sum(bt_5, sum_num=27))
    print "20: " + str(has_path_sum(bt_5, sum_num=20))

    print ""

    print "binary_tree_paths:"
    print binary_tree_paths(bt_5)

    print ""

    print "path_sum_3"
    print "5: " + str(path_sum_3(bt_5, sum_num=5))
    print "0: " + str(path_sum_3(bt_5, sum_num=0))
    print "22: " + str(path_sum_3(bt_5, sum_num=22))
    print "13: " + str(path_sum_3(bt_5, sum_num=13))
    print "17: " + str(path_sum_3(bt_5, sum_num=17))
    print "27: " + str(path_sum_3(bt_5, sum_num=27))
    print "20: " + str(path_sum_3(bt_5, sum_num=20))