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


proc checkExtensionLayers* =
  ## Checks available vulkan extensions
  var
    extCount: uint32
    extensions: array[32, VkExtensionProperties]
  discard vkEnumerateInstanceExtensionProperties(nil, addr extCount, nil)
  discard vkEnumerateInstanceExtensionProperties(nil, addr extCount, cast[ptr VkExtensionProperties](addr extensions))

  for ext in extensions:
    echo $(join(ext.extensionName).toRunes())


proc checkValidationLayers*(validationLayers: openArray[string]): bool =
  ## Returns true when all layers from `validationLayers` is available
  var
    layerCount: uint32 = validationLayers.len.uint32
    availableLayers: array[32, VkLayerProperties]
  discard vkEnumerateInstanceLayerProperties(addr layerCount, nil)
  discard vkEnumerateInstanceLayerProperties(addr layerCount, cast[ptr VkLayerProperties](addr availableLayers))

  for layer in validationLayers:
    var layerFound: bool = false
    for layerProperties in availableLayers:
      if $layer == $(join(layerProperties.layerName).toRunes()):
        layerFound = true
        break
    if not layerFound:
      return false
  
  return true


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


proc display*(m: VulkanManager) =
  ## Displays via Vulkan API
  discard


proc cleanUp*(m: VulkanManager) =
  ## Cleans up vulkan
  vkDestroyInstance(m.instance, nil)
