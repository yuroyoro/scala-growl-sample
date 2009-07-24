package info.growl;

import java.awt.image.RenderedImage;

/**
 * Dummy implementation of the Growl API for situations where the native code
 * cannot be loaded (non-Mac systems).
 * 
 * @author Michael Stringer
 */
class DummyGrowl implements Growl {

    /**
     * {@inheritDoc}
     */
    public void addNotification(String name, boolean enabledByDefault) {
	// does nothing
    }

    /**
     * {@inheritDoc}
     */
    public void register() throws GrowlException {
	// does nothing
    }

    /**
     * {@inheritDoc}
     */
    public void sendNotification(String name, String title, String body)
	    throws GrowlException {
	// does nothing
    }

    /**
     * {@inheritDoc}
     */
    public void sendNotification(String name, String title, String body,
	    RenderedImage icon) throws GrowlException {
	// does nothing
    }

    /**
     * {@inheritDoc}
     */
    public void setIcon(RenderedImage icon) throws GrowlException {
	// does nothing
    }
}
