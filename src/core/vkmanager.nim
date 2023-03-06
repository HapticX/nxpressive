#[
  Provides vulkan wrapper
]#
import
  strutils,
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
  QueueFamilyIndeces* = object
    graphicsFamily*: Option[uint32]
    presentFamily*: Option[uint32]


func isComplete*(a: QueueFamilyIndeces): bool =
  a.graphicsFamily.isSome and a.presentFamily.isSome


proc checkExtensionLayers*: array[32, VkExtensionProperties] {.discardable.} =
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
  extensions


proc checkInstanceLayers*(): array[32, VkLayerProperties] {.discardable.} =
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
  availableLayers


proc checkValidationLayersSupport*(validationLayers: openArray[string] | seq[string]): bool =
  ## Returns true when validation layers is supported
  let layers = checkInstanceLayers()
  
  for layerName in validationLayers:
    var layerFound = false

    for layer in layers:
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
  var indices: QueueFamilyIndeces


proc initVulkan*(): VulkanManager =
  ## Initializes and returns vk instance
  result = VulkanManager()
  let version: uint32 = vkMakeVersion(0, 1, 5)
  result.app_info = newVkApplicationInfo(
    pApplicationName = "HapticX engine",
    pEngineName = "HapticX",
    applicationVersion = 1,
    engineVersion = version,
    apiVersion = version
  )
  result.create_info = newVkInstanceCreateInfo(
    pApplicationInfo = addr result.app_info,
    enabledLayerCount = 0,
    ppEnabledLayerNames = nil,
    enabledExtensionCount = 0,
    ppEnabledExtensionNames = nil
  )
  let res = vkCreateInstance(addr result.create_info, nil, addr result.instance)
  if res != VK_SUCCESS or not vkInit(result.instance):
    raise newException(VkInitDefect, "Error when trying to initialize vulkan")

  checkExtensionLayers()
  checkInstanceLayers()

  echo checkValidationLayersSupport(@["VK_LAYER_AMD_switchable_graphics"])


proc display*(m: VulkanManager) =
  ## Displays via Vulkan API
  discard


proc cleanUp*(m: VulkanManager) =
  ## Cleans up vulkan
  vkDestroyInstance(m.instance, nil)
