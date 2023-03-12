#[
  Provides vulkan wrapper
]#
import
  strutils,
  strformat,
  unicode,
  options,
  ./exceptions,
  ../thirdparty/vulkan


once:
  # Load vulkan library
  vkPreload()


type
  VulkanManager* = object
    instance: VkInstance
    create_info: VkInstanceCreateInfo
    app_info: VkApplicationInfo
    when defined(debug):
      debugger: VkDebugUtilsMessengerEXT
      debugger_create_info: VkDebugUtilsMessengerCreateInfoEXT
  QueueFamilyIndices* = object
    graphicsFamily*: Option[uint32]
    presentFamily*: Option[uint32]


func isComplete*(a: QueueFamilyIndices): bool =
  a.graphicsFamily.isSome and a.presentFamily.isSome


proc checkExtensionLayers*: tuple[count: uint32, arr: array[32, VkExtensionProperties]] {.discardable.} =
  ## Checks available vulkan extensions
  var
    extCount: uint32
    extensions: array[32, VkExtensionProperties]
  discard vkEnumerateInstanceExtensionProperties(nil, addr extCount, nil)
  discard vkEnumerateInstanceExtensionProperties(nil, addr extCount, cast[ptr VkExtensionProperties](addr extensions))

  when defined(debug):
    echo "Available extension layers"
    for ext in extensions:
      echo $(join(ext.extensionName).toRunes())
  (extCount, extensions)


proc checkInstanceLayers*(): tuple[count: uint32, arr: array[32, VkLayerProperties]] {.discardable.} =
  ## Checks available vulkan instance layers
  var
    layerCount: uint32
    availableLayers: array[32, VkLayerProperties]
  discard vkEnumerateInstanceLayerProperties(addr layerCount, nil)
  discard vkEnumerateInstanceLayerProperties(addr layerCount, cast[ptr VkLayerProperties](addr availableLayers))

  when defined(debug):
    echo "Available instance layers"
    for layerProperties in availableLayers:
      echo $(join(layerProperties.layerName).toRunes())
  (layerCount, availableLayers)


proc checkValidationLayersSupport*(validationLayers: openArray[string] | seq[string]): bool =
  ## Returns true when validation layers is supported
  let layers = checkInstanceLayers()
  
  for layerName in validationLayers:
    var layerFound = false

    for layer in layers.arr:
      var name = ""
      for c in layer.layerName:
        if c != '\x00':
          name &= c
      if name == layerName:
        layerFound = true
        break
    
    if not layerFound:
     return false
  true


proc isDeviceSuitable*(device: VkPhysicalDevice): bool =
  ## Check for extension support
  var indices: QueueFamilyIndices


proc initVulkan*(): VulkanManager =
  ## Initializes and returns vk instance
  result = VulkanManager()
  let version: uint32 = vkMakeVersion(0, 1, 5)
  # Register Application info
  result.app_info = newVkApplicationInfo(
    pApplicationName = "HapticX engine",
    pEngineName = "HapticX",
    applicationVersion = 1,
    engineVersion = version,
    apiVersion = vkApiVersion1_2
  )
  when defined(debug):
    ## Adds validation layers in VkInstanceCreateInfo
    var
      # Get all layers
      (extCount, extArr) = checkExtensionLayers()
      (layersCount, layersArr) = checkInstanceLayers()
      # layer name
      name: string
      ppLayers: seq[string] = @[]
      ppExtensions: seq[string] = @[]
    # Extension names handler
    for i in extArr.low..extArr.high:
      name = ""
      for j in extArr[i].extensionName:
        if j != '\x00':
          name &= j
      if name.len > 0:
        ppExtensions.add(name)
    # Instance layer names handler
    for i in layersArr.low..layersArr.high:
      name = ""
      for j in layersArr[i].layerName:
        if j != '\x00':
          name &= j
      if name.len > 0:
        ppLayers.add(name)
    # Add layers into VkInstanceCreateInfo
    result.create_info = newVkInstanceCreateInfo(
      pApplicationInfo = addr result.app_info,
      enabledLayerCount = layersCount,
      ppEnabledLayerNames = allocCStringArray(ppLayers.toOpenArray(ppLayers.low, ppLayers.high)),
      enabledExtensionCount = extCount,
      ppEnabledExtensionNames = allocCStringArray(ppExtensions.toOpenArray(ppExtensions.low, ppExtensions.high))
    )
  else:
    # Without debug mode validation layers is not added
    result.create_info = newVkInstanceCreateInfo(
      pApplicationInfo = addr result.app_info,
      enabledLayerCount = 0,
      ppEnabledLayerNames = nil,
      enabledExtensionCount = 0,
      ppEnabledExtensionNames = nil
    )
  let res = vkCreateInstance(addr result.create_info, nil, addr result.instance)
  # Check for errors
  if res != VK_SUCCESS or not vkInit(result.instance):
    raise newException(VkInitDefect, fmt"Error when trying to initialize vulkan - {res}")
  echo checkValidationLayersSupport(@["VK_LAYER_AMD_switchable_graphics"])


proc display*(m: VulkanManager) =
  ## Displays via Vulkan API
  discard


proc cleanUp*(m: VulkanManager) =
  ## Cleans up vulkan
  vkDestroyInstance(m.instance, nil)
